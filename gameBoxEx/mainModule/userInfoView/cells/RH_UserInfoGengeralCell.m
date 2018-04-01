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
    self.labTitle.textColor = colorWithRGB(51, 51, 51) ;
    self.labTitleValue.textColor = colorWithRGB(51, 51, 51) ;
    self.labTitle.font = [UIFont systemFontOfSize:12.0f] ;
    self.labTitleValue.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.labTitle.text = @"" ;
    self.labTitleValue.text = @"" ;
    if ([THEMEV3 isEqualToString:@"black"]) {
        self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.labTitle.textColor = [UIColor whiteColor] ;
        self.labTitleValue.textColor = [UIColor whiteColor] ;
    }
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_UserApiBalanceModel *userApiBalance = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (userApiBalance){
        self.labTitle.text = userApiBalance.mApiName ;
        self.labTitleValue.text = [NSString stringWithFormat:@"%.2f",userApiBalance.mBalance] ;
    }
}

@end
