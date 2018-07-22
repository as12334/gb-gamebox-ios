//
//  RH_LoginViewCell.h
//  gameBoxEx
//
//  Created by luis on 2017/12/5.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewCell.h"
@class RH_LoginViewCell ;
@protocol LoginViewCellDelegate <NSObject>
-(void)loginViewCellTouchLoginButton:(RH_LoginViewCell*)loginViewCell ;
-(void)loginViewCellTouchCreateButton:(RH_LoginViewCell*)loginViewCell ;
-(void)loginViewCellTouchForgetPasswordButton:(RH_LoginViewCell*)loginViewCell ;
-(void)loginViewCellSelectedEachTextfield:(CGRect)frame;
@end
@interface RH_LoginViewCell : CLTableViewCell
@property(nonatomic,weak) id<LoginViewCellDelegate>  delegate ;
@property(nonatomic,readonly,strong) NSString *userName ;
@property(nonatomic,readonly,strong) NSString *userPassword ;
@property(nonatomic,readonly,strong) NSString *verifyCode ;
@property(nonatomic,assign,readonly) BOOL isRemberPassword ;
@end
