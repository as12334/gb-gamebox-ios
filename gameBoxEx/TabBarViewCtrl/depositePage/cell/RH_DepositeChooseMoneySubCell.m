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

@end
@implementation RH_DepositeChooseMoneySubCell
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    NSString *numStr = ConvertToClassPointer(NSString, context);
    if ([numStr isEqualToString:@"101"]) {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"chip-101"];
    }
    else if ([numStr isEqualToString:@"302"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"chip-302"];
    }
    else if ([numStr isEqualToString:@"504"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"chip-504"];
    }
    else if ([numStr isEqualToString:@"1006"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"chip-1006"];
    }
    else if ([numStr isEqualToString:@"4998"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"chip-4998"];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
