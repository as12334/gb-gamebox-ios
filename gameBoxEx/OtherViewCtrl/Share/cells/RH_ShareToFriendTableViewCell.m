//
//  RH_ShareToFriendTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareToFriendTableViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"
#import "RH_APPDelegate.h"
@interface RH_ShareToFriendTableViewCell ()<UITextFieldDelegate>
@property(nonatomic,strong,readonly)UITextField *textFiled ;
@end

@implementation RH_ShareToFriendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        
        UIView *bgView = [[UIView alloc] init ];
        [self.contentView addSubview:bgView];
        bgView.layer.cornerRadius = 5.f;
        bgView.layer.masksToBounds = YES ;
        bgView.backgroundColor = colorWithRGB(242, 242, 242) ;
        bgView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
        
        UILabel *topLab = [[UILabel alloc] init];
        [bgView addSubview:topLab];
        topLab.whc_LeftSpace(22).whc_TopSpace(17).whc_WidthAuto().whc_Height(20) ;
        topLab.textColor = colorWithRGB(51, 51, 51) ;
        topLab.font = [UIFont systemFontOfSize:14.f] ;
        topLab.text = @"您的专属链接，";
        
        
        UILabel *bottomLab = [[UILabel alloc] init];
        [bgView addSubview:bottomLab];
        bottomLab.whc_LeftSpace(22).whc_TopSpaceToView(5, topLab).whc_WidthAuto().whc_Height(20) ;
        bottomLab.textColor = colorWithRGB(51, 51, 51) ;
        bottomLab.font = [UIFont systemFontOfSize:14.f] ;
        bottomLab.text = @"复制后通过微信、QQ等方式发送给好友";
        
        UITextField *textField = [[UITextField alloc] init ];
        [bgView addSubview:textField];
        textField.whc_TopSpaceToView(13, bottomLab).whc_LeftSpace(22).whc_Width(0.6*screenSize().width).whc_Height(30);
        textField.layer.cornerRadius = 5;
        textField.layer.masksToBounds = YES ;
        textField.layer.borderWidth = 1.f ;
        textField.delegate = self ;
        textField.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
        textField.backgroundColor = [UIColor whiteColor] ;
        _textFiled = textField;
        _textFiled.enabled = NO ;
        
        UIButton *copyBtn = [UIButton new] ;
        [bgView addSubview:copyBtn];
        copyBtn.whc_LeftSpaceToView(12, textField).whc_RightSpace(22).whc_Height(30).whc_TopSpaceToView(13, bottomLab);
        copyBtn.layer.cornerRadius = 5.f;
        copyBtn.layer.masksToBounds = YES ;
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        copyBtn.layer.borderWidth = 1.f ;
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
        [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        if ([THEMEV3 isEqualToString:@"green"]){
            copyBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
            copyBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Green.CGColor;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            copyBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
            copyBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            copyBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
            copyBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Black.CGColor;
        }else{
            copyBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
            copyBtn.layer.borderColor = RH_NavigationBar_BackgroundColor.CGColor;;
        }
        
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *model = ConvertToClassPointer(RH_SharePlayerRecommendModel, context);
    if (model.mCode) {
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
//        if ([model.mCode containsString:@"http:"] || [model.mCode containsString:@"https:"]) {
             _textFiled.text  = [NSString stringWithFormat:@"%@",model.mCode] ;
//        }else
//        {
//             _textFiled.text  = [NSString stringWithFormat:@"%@/%@",appDelegate.headerDomain,model.mCode] ;
//        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.backgroundView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.backgroundView.frame = frame;
    frame = self.contentView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.contentView.frame = frame;
}
//复制的按钮点击
-(void)copyBtnClick
{
    if ([_textFiled.text isEqualToString:@""]) {
        showAlertView(@"提示", @"请填写你发送好友的联系方式");
        return ;
    }else
    {
        [_textFiled endEditing:YES];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _textFiled.text;
        ifRespondsSelector(self.delegate, @selector(shareToFriendTableViewCellDidTouchCopyButton:)){
            [self.delegate shareToFriendTableViewCellDidTouchCopyButton:self];
        }
    }
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
