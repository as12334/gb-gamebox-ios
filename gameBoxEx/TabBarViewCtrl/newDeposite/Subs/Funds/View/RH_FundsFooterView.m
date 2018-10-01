//
//  RH_FundsFooterView.m
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_FundsFooterView.h"

@interface RH_FundsFooterView()

@end
@implementation RH_FundsFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)oneKeyRecoverBtnClick:(id)sender {
    [self.delegate oneKeyRefreshOrRecoveryByTag:1];
}
- (IBAction)oneKeyRefreshBtnClick:(id)sender {
    [self.delegate oneKeyRefreshOrRecoveryByTag:0];
}
@end
