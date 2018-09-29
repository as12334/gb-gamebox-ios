//
//  RH_DepositeChooseMoneySubCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeChooseMoneySubCell.h"
#import "coreLib.h"
#import "RH_API.h"
@interface RH_DepositeChooseMoneySubCell()
@property (weak, nonatomic) IBOutlet UIImageView *chooseMoneyIcon;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
@implementation RH_DepositeChooseMoneySubCell
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    NSDictionary *dic = ConvertToClassPointer(NSDictionary, context);
    NSString *num = dic[@"num"];
    NSString *imageName = dic[@"imageName"];
    self.chooseMoneyIcon.image = [UIImage imageNamed:imageName];
    self.numLab.text = [NSString stringWithFormat:@"%@",num];
    
}

-(void)setSelected:(BOOL)selected {
    if (selected == YES) {
        self.chooseMoneyIcon.transform = CGAffineTransformMakeScale(0.95, 0.95);
        [UIView animateWithDuration:0.3 animations:^{
            self.chooseMoneyIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
