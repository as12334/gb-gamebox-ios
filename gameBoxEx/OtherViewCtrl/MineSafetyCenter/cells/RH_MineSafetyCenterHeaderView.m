//
//  RH_MineSafetyCenterHeaderView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSafetyCenterHeaderView.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_MineSafetyCenterHeaderView()

@property (nonatomic, strong, readonly) UIImageView *image_Back;
@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
@property (nonatomic, strong, readonly) UILabel *label;


@end

@implementation RH_MineSafetyCenterHeaderView
@synthesize image_Back = _image_Back;
@synthesize gradientLayer = _gradientLayer;
@synthesize label = _label;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImageView *)image_Back {
    if (_image_Back == nil) {
        _image_Back = [[UIImageView alloc] init];
//        _image_Back.image = ImageWithName(@"mine_page_safetycenter");
        _image_Back.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image_Back;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.colors = @[(id)colorWithRGB(49, 240, 200).CGColor, (id)colorWithRGB(24, 137, 239).CGColor];
    }
    return _gradientLayer;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        NSString *userName =  MineSettingInfo.mUserName ;
        _label.text = [NSString stringWithFormat:@"亲爱的%@,\n您的账号信息正在享受全面的安全防护",userName];
        _label.textColor = colorWithRGB(255, 255, 255);
        
        _label.font = [UIFont systemFontOfSize:14];
        _label.numberOfLines = 0;
        NSDictionary *dic = @{NSKernAttributeName:@0.f,
                              
                              };
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_label.text attributes:dic];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];//行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_label.text length])];
        [_label setAttributedText:attributedString];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.image_Back];
        self.image_Back.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
        _image_Back.image = ImageWithName(@"safe-bg");
        [self addSubview:self.label];
        self.label.whc_LeftSpace(20).whc_RightSpace(20).whc_BottomSpace(10).whc_Height(60);
    }
    return self;
}

- (void)layoutSubviews {
    self.gradientLayer.frame = self.bounds;
}
@end
