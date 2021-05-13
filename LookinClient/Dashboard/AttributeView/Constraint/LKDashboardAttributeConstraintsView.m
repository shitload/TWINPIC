//
//  LKDashboardAttributeConstraintsView.m
//  Lookin
//
//  Created by Li Kai on 2019/9/12.
//  https://lookin.work
//

#import "LKDashboardAttributeConstraintsView.h"
#import "LookinObject.h"
#import "LKDashboardAttributeConstraintsItemControl.h"
#import "LookinAutoLayoutConstraint.h"
#import "LKConstraintPopoverController.h"
#import "LKDashboardViewController.h"
#import "LKHierarchyDataSource.h"
#import "LookinDisplayItem.h"

@interface LKDashboardAttributeConstraintsView ()

@property(nonatomic, strong) NSMutableArray<LKDashboardAttributeConstraintsItemControl *> *textControls;

@end

@implementation LKDashboardAttributeConstraintsView {
    CGFloat _verInterSpace;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        _verInterSpace = 8;
        
        self.textControls = [NSMutableArray array];
    }
    return self;
}

- (void)renderWithAttribute {
    [super renderWithAttribute];
    
    NSArray<LookinAutoLayoutConstraint *> *rawData = self.attribute.value;
    NSArray<LookinAutoLayoutConstraint *> *sortedRawData = [self _sortedRawD