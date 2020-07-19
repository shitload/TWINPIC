//
//  LKInputSearchSuggestionWindowController.m
//  Lookin
//
//  Created by Li Kai on 2019/6/2.
//  https://lookin.work
//

#import "LKInputSearchSuggestionWindowController.h"
#import "LKInputSearchSuggestionsContentView.h"

@implementation LKInputSearchSuggestionWindowController

- (instancetype)init {
    LKInputSearchSuggestionsContentView *view = [LKInputSearchSuggestionsContentView new];
    
    NSPanel *sugg