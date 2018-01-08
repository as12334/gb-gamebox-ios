//
//  RH_ModifyPasswordCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@interface RH_ModifyPasswordCell : CLTableViewCell

@property (nonatomic, strong, readonly) UITextField *textField;
-(BOOL)isEditing ;
@end
