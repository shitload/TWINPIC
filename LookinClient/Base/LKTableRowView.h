//
//  LKTableRowView.h
//  Lookin
//
//  Created by Li Kai on 2019/4/20.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>

@interface LKTableRowView : NSTableRowView

@property(nonatomic, strong, readonly) LKLabel *titleLabel;
@property(nonatomic, strong, readonly) LKLabel *subtitleLabel;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL isHovered;

@property(nonatomic, assign, readonly) BOOL