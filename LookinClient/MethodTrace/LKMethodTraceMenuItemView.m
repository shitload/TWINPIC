//
//  LKMethodTraceMenuItemView.m
//  Lookin
//
//  Created by Li Kai on 2019/5/24.
//  https://lookin.work
//

#import "LKMethodTraceMenuItemView.h"

@interface LKMethodTraceMenuItemView ()

@property(nonatomic, strong) NSImageView *imageView;
@property(nonatomic, strong) LKLabel *label;
@property(nonatomic, strong) NSButton *deleteButton;

@end

@implementation LKMethodTraceMenuItemView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        self.imageView = [NSImageView new];
        [self addSubview:self.imageView];
        
        self.label = [LKLabel new];
        self.label.font = [NSFont systemFontOfSize:12];
        self.label.maximumNumberOfLines = 1;
        self.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:self.label];
        
        self.deleteButton = [NSButton new];
        self.deleteButton.bezelStyle = NSBezelStyleRoundRect;
        self.deleteButton.bordered = NO;
        self.deleteButton.image = NSImageMake(@"icon_delete");
        self.deleteButton.target = self;
        self.deleteButton.action = @selector(_handleDelete);
        self.deleteButton.hidden = YES;
        [self addSubview:self.deleteButton];
        
        @weakify(self);
        RAC(self.label, stringValue) = [[[RACSignal combineLatest:@[RACObserve(self, representedAsClass),
                                                                    RACObserve(self, representedClassName),
                                                                    RACObserve(self, representedSelName)]]
                                         map:^id _Nullable(RACTuple * _Nullable value) {
                                             return ((NSNumber *)value.first).boolValue ? value.second : valu