//
//  RH_DepositeHeadView.m
//  gameBoxEx
//
//  Created by jun on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_DepositeHeadView.h"
#import "MacroDef.h"
@interface RH_DepositeHeadView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation RH_DepositeHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLab.font = [UIFont systemFontOfSize:13 * WIDTH_PERCENT];
}
- (IBAction)deleteBtnClick:(id)sender {
    [self removeFromSuperview];
    [self.delegate closeBtnClick];
}
@end
