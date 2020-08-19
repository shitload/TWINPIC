
//
//  LKTableView.h
//  Lookin
//
//  Created by Li Kai on 2019/4/20.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>

@class LKTableView;

@protocol LKTableViewDelegate <NSTableViewDelegate>

@optional

/// 以下方法的 row 均可能为 -1
- (void)tableView:(LKTableView *)tableView didSelectRow:(NSInteger)row;
- (void)tableView:(LKTableView *)tableView didHoverAtRow:(NSInteger)row;
- (void)tableView:(LKTableView *)tableView didDoubleClickAtRow:(NSInteger)row;
// 点击了空白处
- (void)tableViewDidClickBlankArea:(LKTableView *)tableView;

@end

@protocol LKTableViewDataSource <NSTableViewDataSource>

@end

@interface LKTableView : NSScrollView

@property(nonatomic, strong, readonly) NSTableView *tableView;
