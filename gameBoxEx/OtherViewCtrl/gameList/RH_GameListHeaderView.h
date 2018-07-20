//
//  RH_GameListHeaderView.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_GameListHeaderView ;
@protocol GameListHeaderViewDelegate
@optional
-(void)gameListHeaderViewDidChangedSelectedIndex:(RH_GameListHeaderView*)gameListHeaderView SelectedIndex:(NSInteger)selectedIndex ;
@end

@interface RH_GameListHeaderView : UIView
@property (nonatomic,weak) id<GameListHeaderViewDelegate> delegate ;

@property (nonatomic,assign,readonly) NSInteger allTypes ;
@property (nonatomic,assign) NSInteger selectedIndex ;

-(void)updateView:(NSArray*)typeList ;
-(NSDictionary *)typeModelWithIndex:(NSInteger)index ;

@end
