//
//  UIActionSheet+Block.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheetCallBackBlock)(UIActionSheet * actionSheet,NSInteger buttonIndex);

@interface UIActionSheet (Block)<UIActionSheetDelegate>
@property(nonatomic,copy) UIActionSheetCallBackBlock actionSheetCallBackBlock;

+ (instancetype)actionViewWithCallBackBlock:(UIActionSheetCallBackBlock)alertViewCallBackBlock
                                      title:(NSString *)title
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                     destructiveButtonTitle:(NSString *)destructiveButtonTitle
                          otherButtonTitles:( NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
