//
//  RH_PreferentialListCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PreferentialListCell.h"
#import "coreLib.h"
#import "RH_PromoInfoModel.h"

@interface RH_PreferentialListCell ()
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_Bottom;
@property (weak, nonatomic) IBOutlet UILabel *label_Time;
@property (weak, nonatomic) IBOutlet UIImageView *image_Right;
@property (weak, nonatomic) IBOutlet UILabel *label_RightMoney;
@property (weak, nonatomic) IBOutlet UILabel *label_Grant;
@property (nonatomic,strong) RH_PromoInfoModel *promoInfoModel ;

@end



@implementation RH_PreferentialListCell

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 95.0f ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.label_Title.whc_TopSpace(15).whc_LeftSpaceEqualViewOffset(self.image_Right, 20).whc_Height(40).whc_Width(screenSize().width - 25 - screenSize().width/3.0);
    self.label_Title.numberOfLines = 0 ;
    self.label_Bottom.whc_BottomSpace(15).whc_LeftSpaceEqualView(self.label_Title).whc_Height(15).whc_Width(120);
    self.label_Time.whc_BottomSpace(15).whc_CenterX(0).whc_Height(20).whc_Width(160);
    self.label_RightMoney.whc_TopSpace(10).whc_RightSpace(10).whc_Width(100).whc_Height(30);
    self.label_Grant.whc_CenterToView(CGPointMake(0, 30), self.label_RightMoney);
    
    self.label_Title.textColor = colorWithRGB(68, 68, 68);
    self.label_Title.font = [UIFont systemFontOfSize:14];
    self.label_Bottom.textColor = colorWithRGB(153, 153, 153);
    self.label_Bottom.font = [UIFont systemFontOfSize:12];
    self.label_Time.font = [UIFont systemFontOfSize:12];
    self.label_Time.textColor = colorWithRGB(153, 153, 153);
    self.label_RightMoney.font = [UIFont systemFontOfSize:17];
    self.label_RightMoney.textColor = colorWithRGB(255, 255, 255);
    self.label_RightMoney.textAlignment = NSTextAlignmentCenter;
    self.label_Grant.font = [UIFont systemFontOfSize:14];
    self.label_Grant.textColor = colorWithRGB(255, 255, 255);
    self.label_Grant.textAlignment = NSTextAlignmentCenter;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.promoInfoModel = ConvertToClassPointer(RH_PromoInfoModel, context) ;
    self.label_Title.text = self.promoInfoModel.mActivityName ;
    if (self.promoInfoModel.mPreferentialAudit == 0) {
         self.label_Bottom.text = [NSString stringWithFormat:@"%@",self.promoInfoModel.mPreferentialAuditName];
    }else
    {
        self.label_Bottom.text = [NSString stringWithFormat:@"%.2f%@",self.promoInfoModel.mPreferentialAudit,self.promoInfoModel.mPreferentialAuditName];
    }
    
    self.label_Time.text = self.promoInfoModel.showApplyTime ;
    self.label_RightMoney.text = self.promoInfoModel.showPreferentialValue ;
    self.label_Grant.text = self.promoInfoModel.mCheckStateName ;

    if (self.promoInfoModel.mCheckState == 2 || self.promoInfoModel.mCheckState == 4 || [self.promoInfoModel.mCheckStateName isEqualToString:@"已发放"])
    {
        self.image_Right.image = ImageWithName(@"mine_preferentialbackgreen");
    }
    else if (self.promoInfoModel.mCheckState == 1 || [self.promoInfoModel.mCheckStateName isEqualToString:@"待审核"])
    {
         self.image_Right.image = ImageWithName(@"mine_preferentialbackorange");
    }
    else if (self.promoInfoModel.mCheckState == 0 || [self.promoInfoModel.mCheckStateName isEqualToString:@"进行中"])
    {
         self.image_Right.image = ImageWithName(@"mine_preferentialbackgreen");
    }
    else  //未通过
    {
        self.image_Right.image = ImageWithName(@"mine_preferentialbackgray");
    }
    
    
}

@end
