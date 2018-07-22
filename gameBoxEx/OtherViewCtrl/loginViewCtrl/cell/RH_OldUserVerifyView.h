//
//  RH_OldUserVerifyView.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_OldUserVerifyView;
@protocol RH_OldUserVerifyViewDelegate <NSObject>
@optional
-(void)oldUserVerifyViewDidTochSureBtn:(RH_OldUserVerifyView *)oldUserVerifyView withRealName:(NSString *)realName;
-(void)oldUserVerifyViewDidTochCancleBtn:(RH_OldUserVerifyView *)oldUserVerifyView;
@end

@interface RH_OldUserVerifyView : UIView
@property(nonatomic,weak)id <RH_OldUserVerifyViewDelegate> delegate ;
@end
