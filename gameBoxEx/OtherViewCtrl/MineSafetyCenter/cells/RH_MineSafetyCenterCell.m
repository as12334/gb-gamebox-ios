//
//  RH_MineSafetyCenterCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSafetyCenterCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_BankCardModel.h"
@implementation RH_MineSafetyCenterCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 44;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.backgroundColor = colorWithRGB(242, 242, 242);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
       
        self.bankNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frameWidth/4.0, 0, self.frameWidth/4.3, 40)];
        
        /*此标签等后台返回图片就用上面的imageview*/
        self.bankCradLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frameWidth/4, 0, (self.frameWidth)/4.3, 40)];
        self.bankCradLabel.textColor = colorWithRGB(51, 51, 51);
        self.bankCradLabel.font = [UIFont systemFontOfSize:12.f];
        self.bankCradLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.bankCradLabel];
        
        
        self.bankNamelabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frameWidth)/2.0, 0, (self.frameWidth)/5, 40)];
        self.bankNamelabel.textColor = colorWithRGB(23, 102, 187);
        self.bankNamelabel.font = [UIFont systemFontOfSize:12.f];
        self.bankNamelabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.bankNamelabel];
    }
    return self;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.detailTextLabel.text = info[@"detailTitle"];
    self.textLabel.text = info[@"title"];
    
    RH_BankCardModel *bankModel = ConvertToClassPointer(RH_BankCardModel, context);
    if (!bankModel) {
        return;
    }
    [self.bankNameImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bankModel.mbankUrl]]];
    self.bankCradLabel.text = [NSString stringWithFormat:@"%@",bankModel.mBankCode];
    self.bankNamelabel.text = [NSString stringWithFormat:@"%@",[bankModel.mBankCardNumber substringFromIndex:bankModel.mBankCardNumber.length-9]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
