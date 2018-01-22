//
//  RH_SiteSendMessageView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_SendMessageVerityModel.h"
typedef void (^SiteSendMessageViewBlock)(CGRect frame);
typedef void (^SiteSendMessageViewSubmitBlock)(NSString *titelStr,NSString *contenStr,NSString *codeStr);
@interface RH_SiteSendMessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(nonatomic,copy)SiteSendMessageViewBlock block;
@property(nonatomic,copy)SiteSendMessageViewSubmitBlock submitBlock;
@property(nonatomic,strong)RH_SendMessageVerityModel *sendModel;
@end
