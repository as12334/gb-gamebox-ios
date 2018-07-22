//
//  RH_GameListScrollView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_GameListScrollView;

@protocol RH_GameListScrollViewDelegate

- (void)gameListScrollView:(RH_GameListScrollView *)view scrolledAt:(int)index;

@end

@protocol RH_GameListScrollViewDatasource

@required
- (NSInteger)numberOfPagesInScrollView:(RH_GameListScrollView *)view;
//- (id)scrollView:(RH_GameListScrollView *)view pageForRowAtIndex:(NSInteger)index;

@end


@interface RH_GameListScrollView : UIScrollView

- (void)reload;

@property (nonatomic, weak) id <RH_GameListScrollViewDelegate> pageDelegate;
@property (nonatomic, weak) id <RH_GameListScrollViewDatasource> datasource;

@end
