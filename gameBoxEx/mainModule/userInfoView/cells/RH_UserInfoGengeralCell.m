//
//  RH_UserInfoGengeralCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoGengeralCell.h"
#import "coreLib.h"
#import "RH_UserApiBalanceModel.h"

@interface RH_UserInfoGengeralCell()
@property (weak, nonatomic) IBOutlet UILabel *labTitle          ;
@property (weak, nonatomic) IBOutlet UILabel *labTitleValue     ;

@end
@implementation RH_UserInfoGengeralCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 30;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor] ;
    
    // Initialization code
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    
    self.labTitle.text = @"" ;
    self.labTitleValue.text = @"" ;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    }
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_UserApiBalanceModel *userApiBalance = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (userApiBalance.Index == 1) {
        self.contentView.backgroundColor = colorWithRGB(50, 55, 59);
    } else {
        self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    }
    if (userApiBalance){
        self.labTitle.text = userApiBalance.mApiName ;
        self.labTitleValue.text = [NSString stringWithFormat:@"%.2f",userApiBalance.mBalance] ;
    }
}

@end
