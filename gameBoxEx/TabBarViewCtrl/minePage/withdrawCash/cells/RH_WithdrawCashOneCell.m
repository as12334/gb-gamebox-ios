//
//  RH_WithdrawCashOneCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawCashOneCell.h"
#import "coreLib.h"
#import "RH_WithDrawModel.h"

@interface RH_WithdrawCashOneCell ()
@property(nonatomic,strong) UIImageView *bankIconImageView ;
@property(nonatomic,strong) UILabel *bankUserNameLb ;
@property(nonatomic,strong)UILabel *bankCardLab ;

@end

@implementation RH_WithdrawCashOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)bankIconImageView
{
    if (!_bankIconImageView) {
        _bankIconImageView = [[UIImageView alloc] init];
    }
    return _bankIconImageView;
}

-(UILabel *)bankUserNameLb
{
    if (!_bankUserNameLb) {
        _bankUserNameLb = [[UILabel alloc] init];
        _bankUserNameLb.font = [UIFont systemFontOfSize:14.f];
        _bankUserNameLb.textColor = colorWithRGB(68, 68, 68);
        
    }
    return _bankUserNameLb;
}

-(UILabel *)bankCardLab
{
    if (!_bankCardLab) {
        _bankCardLab = [[UILabel alloc] init];
        _bankCardLab.font = [UIFont systemFontOfSize:14.f];
        _bankCardLab.textColor = colorWithRGB(68, 68, 68);
    }
    return _bankCardLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bankIconImageView];
        [self.contentView addSubview:self.bankUserNameLb];
        [self.contentView addSubview:self.bankCardLab];
        self.bankIconImageView.whc_LeftSpace(10).whc_WidthAuto().whc_Height(30).whc_CenterY(0);
       
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(242, 242, 242);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.backgroundColor = colorWithRGB(255, 255, 255);
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
    }
    return self;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    BankcardMapModel *bankcardModel = ConvertToClassPointer(BankcardMapModel, context) ;
    self.textLabel.text = bankcardModel.mBankName;
//    self.
}

@end
