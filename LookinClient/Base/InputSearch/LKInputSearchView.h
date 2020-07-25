//
//  LKInputSearchView.h
//  Lookin
//
//  Created by Li Kai on 2019/6/2.
//  https://lookin.work
//

#import "LKBaseView.h"

@class LKInputSearchSuggestionItem, LKInputSearchView;

@protocol LKInputSearchViewDelegate <NSObject>

- (NSArray<LKInputSearchSuggestionItem *> *)inputSearchView:(LKInputSearchView *)view suggestionsForString:(NSString *)string;

- (void)inputSearchView:(LKInputSearchView *)view submitText:(NSString *)text;

@e