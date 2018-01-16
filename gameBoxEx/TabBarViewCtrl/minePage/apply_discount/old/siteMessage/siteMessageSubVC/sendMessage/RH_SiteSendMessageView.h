//
//  RH_SiteSendMessageView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SiteSendMessageViewBlock)(CGRect frame);
@interface RH_SiteSendMessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(nonatomic,copy)SiteSendMessageViewBlock block;
@end
