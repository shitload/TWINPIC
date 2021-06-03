//
//  LKDashboardAttributeView.h
//  Lookin
//
//  Created by Li Kai on 2018/11/18.
//  https://lookin.work
//

#import "LookinAttribute.h"
#import "LookinDefines.h"
#import "LookinAttributesGroup.h"

@class LookinDisplayItem, LKDashboardAttributeValueView, LKDashboardViewController;

@interface LKDashboardAttributeView : LKBaseView

@property(nonatomic, strong) LookinAttribute *attribute;

@property(nonatomic, strong) id valueView;

@property(nonatomic, weak) LKDashboardViewController *dashboardViewController;

- (BOOL)canEdit;

