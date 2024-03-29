//
//  RH_SiteSendMessageView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_SendMessageVerityModel.h"
@class RH_SiteSendMessageView ;
typedef void (^SiteSendMessageViewBlock)(CGRect frame);
typedef void (^SiteSendMessageViewSubmitBlock)(NSString *titelStr,NSString *contenStr,NSString *codeStr);
//typedef void (^SiteSendMessageViewSubmitSuccessBlock)(NSString *titelStr,NSString *contenStr);

@protocol RH_SiteSendMessageViewDelegate<NSObject>
@optional
-(void)selectedCodeTextFieldAndChangedKeyboardFrame:(CGRect )frame;
-(void)siteSendMessageViewDidTouchCancelBtn:(RH_SiteSendMessageView *)siteSendMessageView;
@end
@interface RH_SiteSendMessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(nonatomic,copy)SiteSendMessageViewBlock block;
@property(nonatomic,copy)SiteSendMessageViewSubmitBlock submitBlock;
//@property (nonatomic, copy) SiteSendMessageViewSubmitSuccessBlock submitSuccessBlock;
@property(nonatomic,strong)RH_SendMessageVerityModel *sendModel;
@property(nonatomic,weak)id<RH_SiteSendMessageViewDelegate>delegate;
@end
