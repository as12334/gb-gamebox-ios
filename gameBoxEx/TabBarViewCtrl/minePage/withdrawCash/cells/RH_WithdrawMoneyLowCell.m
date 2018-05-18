//
//  RH_WithdrawMoneyLowCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawMoneyLowCell.h"
#import "coreLib.h"
#import "RH_WithDrawModel.h"

@interface RH_WithdrawMoneyLowCell()
@property (weak, nonatomic) IBOutlet UILabel *label_Notice;

@property (weak, nonatomic) IBOutlet UIButton *button_Save;

@end

@implementation RH_WithdrawMoneyLowCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return screenSize().height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *imageC = [UIImageView new];
    [self.contentView addSubview:imageC];
    imageC.whc_TopSpace(48).whc_CenterX(0).whc_Width(118).whc_Height(118);
    imageC.image = ImageWithName(@"icon-text");
    
    self.label_Notice.whc_TopSpaceToView(12, imageC).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(60);
    self.button_Save.whc_TopSpaceToView(20, self.label_Notice).whc_CenterX(0).whc_Width(100).whc_Height(44);
    self.label_Notice.text = @"取款金额至少为100.00元\n您当前钱包余额不足!";
    self.label_Notice.textColor = RH_Label_DefaultTextColor;
    NSDictionary *dic = @{NSKernAttributeName:@1.f,
                          
                          };
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.label_Notice.text attributes:dic];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.label_Notice.text length])];
    [self.label_Notice setAttributedText:attributedString];
    self.label_Notice.textAlignment = NSTextAlignmentCenter;
    self.button_Save.layer.cornerRadius = 5.0;
    if ([THEMEV3 isEqualToString:@"green"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        self.button_Save.backgroundColor = colorWithRGB(11, 102, 75);
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor;
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
    }else{
        self.button_Save.backgroundColor = RH_NavigationBar_BackgroundColor;
    }
    self.clipsToBounds = YES;
    [self.button_Save addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSString *textStr = ConvertToClassPointer(NSString, context) ;
    self.label_Notice.text = [NSString stringWithFormat:@"%@\n您当前钱包余额不足!",textStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonDidClick {
    ifRespondsSelector(self.delegate, @selector(withdrawMoneyLowCellDidTouchQuickButton:)){
        [self.delegate withdrawMoneyLowCellDidTouchQuickButton:self] ;
    }
}

@end
