//
//  RH_ModifyPasswordCodeCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@interface RH_ModifyPasswordCodeCell : CLTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *loginVerifyCodeImage;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UILabel *label_indicator;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@end
