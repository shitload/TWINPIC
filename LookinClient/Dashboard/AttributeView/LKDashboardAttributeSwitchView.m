
//
//  LKDashboardAttributeToggleView.m
//  Lookin
//
//  Created by Li Kai on 2019/2/21.
//  https://lookin.work
//

#import "LKDashboardAttributeSwitchView.h"
#import "LKDashboardCardView.h"
#import "LKDashboardViewController.h"
#import "LookinDashboardBlueprint.h"

@interface LKDashboardAttributeSwitchView ()

@property(nonatomic, strong) NSButton *button;

@end

@implementation LKDashboardAttributeSwitchView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[NSColor blueColor]];
        
        self.button = [NSButton new];
        self.button.ignoresMultiClick = YES;
        [self.button setButtonType:NSButtonTypeSwitch];
        self.button.target = self;
        self.button.action = @selector(_handleButton);
        self.button.font = NSFontMake(13);
        [self addSubview:self.button];
    }
    return self;
}

- (void)layout {
    [super layout];
    $(self.button).fullFrame;
}

- (void)renderWithAttribute {
    NSString *title = [LookinDashboardBlueprint briefTitleWithAttrID:self.attribute.identifier];
    [self.button setAttributedTitle:$(title).textColor([NSColor colorNamed:@"DashboardCardValueColor"]).attrString];
    
    BOOL boolValue = ((NSNumber *)self.attribute.value).boolValue;
    self.button.state = boolValue ? NSControlStateValueOn : NSControlStateValueOff;
    self.button.enabled = [self canEdit];
    
    [self setNeedsLayout:YES];
}

- (NSSize)sizeThatFits:(NSSize)limitedSize {
    NSSize size = [self.button sizeThatFits:limitedSize];
    // 不知道为什么，sizeThatFits: 返回的 size 并不够
    return NSMakeSize(size.width + 3, size.height + 2);
}

- (NSUInteger)numberOfColumnsOccupied {