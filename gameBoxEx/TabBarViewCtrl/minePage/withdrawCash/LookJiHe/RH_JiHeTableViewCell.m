//
//  RH_JiHeTableViewCell.m
//  gameBoxEx
//
//  Created by jun on 2018/8/24.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_JiHeTableViewCell.h"
#import "coreLib.h"
@interface RH_JiHeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间
@property (weak, nonatomic) IBOutlet UILabel *CKJELab;//存款金额
@property (weak, nonatomic) IBOutlet UILabel *CKJHDLab;//存款稽核点
@property (weak, nonatomic) IBOutlet UILabel *XZFYLab;//行政费用
@property (weak, nonatomic) IBOutlet UILabel *YHJELab;//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *YHJHDLab;//优惠稽核点
@property (weak, nonatomic) IBOutlet UILabel *YHKCLab;//优惠扣除

@end
@implementation RH_JiHeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUIWithDictionary:(NSDictionary *)dic{
    NSString *creatTime = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
    NSString *time;
    if ([creatTime isEqualToString:@"存款时间"]) {
        time = creatTime;
    }else{
          NSDate *date = [NSDate dateWithTimeIntervalSince1970:[creatTime floatValue]/1000.0];
        time = dateStringWithFormatter(date, @"yyyy-MM-dd HH:mm:ss");
    }
  
    self.timeLab.text = time;
    NSString *rechargeAmount = [NSString stringWithFormat:@"%@",dic[@"rechargeAmount"]];
    NSString *str;
    if ([rechargeAmount isEqualToString:@"存款金额"]) {
        str = rechargeAmount;
    }else{
        str = [NSString stringWithFormat:@"￥%.1f",[rechargeAmount floatValue]];
    }
    self.CKJELab.text = str;
    
    NSString *rechargeAudit = [NSString stringWithFormat:@"%@",dic[@"rechargeAudit"]];
    NSString *rechargeRemindAudit = [NSString stringWithFormat:@"%@",dic[@"rechargeRemindAudit"]];
    NSString *str4;
    if ([rechargeAudit isEqualToString:@"存款稽核点"]) {
        str4 = rechargeAudit;
    }else{
        str4 = [NSString stringWithFormat:@"%.1f/%.1f",[rechargeRemindAudit floatValue],[rechargeAudit floatValue]];
    }
    self.CKJHDLab.text = str4;
    NSString *rechargeFee = [NSString stringWithFormat:@"%@",dic[@"rechargeFee"]];
    NSString *str1;
    if ([rechargeFee integerValue] == 0) {
        str1 = @"通过";
    }else{
        str1 = rechargeFee;
    }
    self.XZFYLab.text = str1;
    NSString *favorableAmount = [NSString stringWithFormat:@"%@",dic[@"favorableAmount"]];
    NSString *str2;
    if ([rechargeAmount isEqualToString:@"优惠金额"]) {
        str2 = favorableAmount;
    }else{
        str2 = [NSString stringWithFormat:@"￥%.1f",[favorableAmount floatValue]];
    }
    self.YHJELab.text = str2;
    
    NSString *favorableAudit = [NSString stringWithFormat:@"%@",dic[@"favorableAudit"]];
    NSString *favorableRemindAudit = [NSString stringWithFormat:@"%@",dic[@"favorableRemindAudit"]];
    NSString *str5;
    if ([favorableAudit isEqualToString:@"优惠稽核点"]) {
        str5 = favorableAudit;
    }else{
        str5 = [NSString stringWithFormat:@"%.1f/%.1f",[favorableRemindAudit floatValue],[favorableAudit floatValue]];
    }
    self.YHJHDLab.text = str5;
    NSString *favorableFee = [NSString stringWithFormat:@"%@",dic[@"favorableFee"]];
    NSString *str3;
    if ([favorableFee integerValue] == 0) {
        str3 = @"通过";
    }else{
        str3 = favorableFee;
    }
    self.YHKCLab.text = str3;
}
@end
