
//
//  LKHierarchyDataSource.m
//  Lookin
//
//  Created by Li Kai on 2019/5/6.
//  https://lookin.work
//

#import "LKHierarchyDataSource.h"
#import "LookinHierarchyInfo.h"
#import "LookinDisplayItem.h"
#import "LKPreferenceManager.h"
#import "LKColorIndicatorLayer.h"
#import "LKUserActionManager.h"
@import AppCenter;
@import AppCenterAnalytics;

@interface LKSelectColorItem : NSObject

+ (instancetype)itemWithTitle:(NSString *)title color:(LookinColor *)color;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSColor *color;

@end

@implementation LKSelectColorItem

+ (instancetype)itemWithTitle:(NSString *)title color:(LookinColor *)color {
    LKSelectColorItem *item = [LKSelectColorItem new];
    item.title = title;
    item.color = color;
    return item;
}

@end

@interface LKSelectColorItemsSection : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSArray<LKSelectColorItem *> *items;

@end

@implementation LKSelectColorItemsSection

- (void)setItems:(NSArray<LKSelectColorItem *> *)items {
    _items = [items sortedArrayUsingComparator:^NSComparisonResult(LKSelectColorItem * _Nonnull obj1, LKSelectColorItem * _Nonnull obj2) {
        return [obj1.title caseInsensitiveCompare:obj2.title];
    }].copy;
}

@end

@interface LookinDisplayItem (LKHierarchyDataSource)

/// 记录搜索之前的 isExpanded 的值，用来在结束搜索后恢复
@property(nonatomic, assign) BOOL isExpandedBeforeSearching;

@end

@implementation LookinDisplayItem (LKHierarchyDataSource)

- (void)setIsExpandedBeforeSearching:(BOOL)isExpandedBeforeSearching {
    [self lookin_bindBOOL:isExpandedBeforeSearching forKey:@"isExpandedBeforeSearching"];
}

- (BOOL)isExpandedBeforeSearching {
    return [self lookin_getBindBOOLForKey:@"isExpandedBeforeSearching"];
}

@end

@interface LKHierarchyDataSource ()

@property(nonatomic, strong, readwrite) LookinHierarchyInfo *rawHierarchyInfo;

/// 非搜索状态下，rawFlatItems 和 flatItems 一致。搜索状态下，flatItems 仅包含搜索结果，而 rawFlatItems 则仍保持为非搜索状态下的值，可用来在结束搜索时恢复
@property(nonatomic, copy) NSArray<LookinDisplayItem *> *rawFlatItems;
@property(nonatomic, copy, readwrite) NSArray<LookinDisplayItem *> *flatItems;

@property(nonatomic, copy, readwrite) NSArray<LookinDisplayItem *> *displayingFlatItems;

@property(nonatomic, strong, readwrite) NSMenu *selectColorMenu;
@property(nonatomic, copy) NSDictionary<NSNumber *, LookinDisplayItem *> *oidToDisplayItemMap;

/**
 key 是 rgba 字符串，value 是 alias 字符串数组，比如：
 
 @{
 @"(255, 255, 255, 1)": @[@"MyWhite", @"MainThemeWhite"],
 @"(255, 0, 0, 0.5)": @[@"BestRed", @"TransparentRed"]
 };
 
 */
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *colorToAliasMap;

@property(nonatomic, assign, readwrite) BOOL isSearching;

@end

@implementation LKHierarchyDataSource

- (instancetype)init {
    if (self = [super init]) {
        _itemDidChangeHiddenAlphaValue = [RACSubject subject];
        _itemDidChangeAttrGroup = [RACSubject subject];
        _itemDidChangeNoPreview = [RACSubject subject];
        _didReloadHierarchyInfo = [RACSubject subject];
        _didReloadFlatItemsWithSearch = [RACSubject subject];
        
        @weakify(self);
        [[[RACObserve([LKPreferenceManager mainManager], rgbaFormat) skip:1] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self _setUpColors];
        }];
    }
    return self;
}

- (void)reloadWithHierarchyInfo:(LookinHierarchyInfo *)info keepState:(BOOL)keepState {
    self.rawHierarchyInfo = info;

    if (info.colorAlias.count) {
        [LKPreferenceManager mainManager].receivingConfigTime_Color = [[NSDate date] timeIntervalSince1970];
    }
    if (info.collapsedClassList.count) {
        [LKPreferenceManager mainManager].receivingConfigTime_Class = [[NSDate date] timeIntervalSince1970];
    }
    
    unsigned long prevSelectedOid = 0;
    NSMutableDictionary *prevExpansionMap = nil;
    if (keepState) {
        prevSelectedOid = self.selectedItem.layerObject.oid;
        
        prevExpansionMap = [NSMutableDictionary dictionary];
        [self.flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            prevExpansionMap[@(obj.layerObject.oid)] = @(obj.isExpanded);
        }];
    }
    
    // 设置 color alias 和 select color menu
    [self _setUpColors];
    
    // 根据 subitems 属性打平为二维数组，同时给每个 item 设置 indentLevel
    self.rawFlatItems = [LookinDisplayItem flatItemsFromHierarchicalItems:info.displayItems];
    NSArray<LookinDisplayItem *> *flatItems = self.rawFlatItems.copy;
    
    // 设置 preferToBeCollapsed 属性
    NSSet<NSString *> *classesPreferredToCollapse = [NSSet setWithObjects:@"UILabel", @"UIPickerView", @"UIProgressView", @"UIActivityIndicatorView", @"UIAlertView", @"UIActionSheet", @"UISearchBar", @"UIButton", @"UITextView", @"UIDatePicker", @"UIPageControl", @"UISegmentedControl", @"UITextField", @"UISlider", @"UISwitch", @"UIVisualEffectView", @"UIImageView", @"WKCommonWebView", @"UITextEffectsWindow", @"LKS_LocalInspectContainerWindow", nil];
    if (info.collapsedClassList.count) {
        classesPreferredToCollapse = [classesPreferredToCollapse setByAddingObjectsFromArray:info.collapsedClassList];
    }
    // no preview
    NSSet<NSString *> *classesWithNoPreview = [NSSet setWithArray:@[@"UITextEffectsWindow", @"UIRemoteKeyboardWindow", @"LKS_LocalInspectContainerWindow"]];
    
    __block BOOL isSwiftProject = NO;
    [flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj itemIsKindOfClassesWithNames:classesPreferredToCollapse]) {
            [obj enumerateSelfAndChildren:^(LookinDisplayItem *item) {
                item.preferToBeCollapsed = YES;
            }];
        }
        
        if (obj.indentLevel == 0) {
            if ([obj itemIsKindOfClassesWithNames:classesWithNoPreview]) {
                obj.noPreview = YES;
            }
        }
        
        if (!obj.shouldCaptureImage) {
            [obj enumerateSelfAndChildren:^(LookinDisplayItem *item) {
                item.noPreview = YES;
                item.doNotFetchScreenshotReason = LookinDoNotFetchScreenshotForUserConfig;
            }];
        }
        
        if (!isSwiftProject) {
            if ([obj.displayingObject.completedSelfClassName containsString:@"."]) {
                isSwiftProject = YES;
            }
        }
    }];
    
    self.flatItems = flatItems;
    
    // 设置选中
    LookinDisplayItem *shouldSelectedItem = nil;
    if (keepState) {
        LookinDisplayItem *prevSelectedItem = [self displayItemWithOid:prevSelectedOid];
        if (prevSelectedItem) {
            shouldSelectedItem = prevSelectedItem;
        }
    }

    // 设置展开和折叠
    NSInteger expansionIndex = self.preferenceManager.expansionIndex;
    if (self.flatItems.count > 300) {
        if (expansionIndex > 2) {
            expansionIndex = 2;
        }
    }
    [self adjustExpansionByIndex:expansionIndex referenceDict:(keepState ? prevExpansionMap : nil) selectedItem:(shouldSelectedItem ? nil : &shouldSelectedItem)];
    
    if (self.flatItems.count > 20 && self.displayingFlatItems.count < 10 && expansionIndex > 1) {
        // 被展开的图层太少了，所以忽略 referDict 重新调整。通常是由于 iOS App 重新编译或者界面改变了导致之前被展开的图层都被释放掉了
        NSLog(@"adjust expansion again");
        [self adjustExpansionByIndex:expansionIndex referenceDict:nil selectedItem:nil];
    }
    