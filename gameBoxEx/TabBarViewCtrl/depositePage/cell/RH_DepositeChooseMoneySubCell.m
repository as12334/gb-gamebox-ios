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
    if ([numStr isEqualToString:@"100"]) {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"100"];
    }
    else if ([numStr isEqualToString:@"200"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"200"];
    }
    else if ([numStr isEqualToString:@"500"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"500"];
    }
    else if ([numStr isEqualToString:@"1000"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"1000"];
    }
    else if ([numStr isEqualToString:@"5000"])
    {
        self.chooseMoneyIcon.image = [UIImage imageNamed:@"5000"];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
