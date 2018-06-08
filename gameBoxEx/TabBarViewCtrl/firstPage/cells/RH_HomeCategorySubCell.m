//
//  RH_HomeCategorySubCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategorySubCell.h"
#import "coreLib.h"
#import "RH_LotteryCategoryModel.h"

@interface RH_HomeCategorySubCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet CLBorderView *borderView ;
@property (weak, nonatomic) IBOutlet CLBorderView *bgView;
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) RH_LotteryCategoryModel *lotteryCategoryModel ;
@property (nonatomic, strong) UIImageView *imageB;
@property (nonatomic,strong) UIView *lineView;
//向下指示图
@property (nonatomic,strong) IBOutlet UIImageView *indicatorImgView ;

@end

@implementation RH_HomeCategorySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f]    ;
    self.labTitle.textColor =  [UIColor blackColor] ;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.labTitle.textColor =  [UIColor whiteColor] ;
        self.backgroundColor = colorWithRGB(37, 37, 37) ;
    }else{
        self.backgroundColor = colorWithRGB(239, 239, 239) ;
        self.bgView.backgroundColor = colorWithRGB(247, 247, 247);
    }
    self.imgIcon.whc_TopSpace(4).whc_CenterX(0).whc_Width(25).whc_Height(25);
    self.selectionOption = CLSelectionOptionNone ;
    self.borderMask = CLBorderMarkNone ;
    self.borderView.borderColor = RH_Line_DefaultColor ;
    self.indicatorImgView.hidden = YES ;
    self.borderView.whc_TopSpace(0);
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated] ;
    self.indicatorImgView.hidden = !selected ;
    if (selected) {
        if (self.imageB.superview == nil) {
            self.imageB = [UIImageView new];
        }
        [self.borderView insertSubview:self.imageB atIndex:0];
        self.imageB.image = ImageWithName(@"nav-hover-bg");
        self.imageB.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
        if (self.lineView.superview==nil){
            self.lineView = [[UIView alloc] init] ;
        }
        [self.borderView insertSubview:self.lineView belowSubview:self.indicatorImgView] ;
        self.lineView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Height(1) ;
//        self.imgIcon.alpha = 0.0;
        if ([THEMEV3 isEqualToString:@"green"]){
//            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Green ;
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.labTitle.textColor = colorWithRGB(30, 161, 114) ;
            self.indicatorImgView.alpha = 0.0;
//            self.lineView.backgroundColor = [UIColor greenColor];
        }else if ([THEMEV3 isEqualToString:@"red"]){
            self.labTitle.textColor = [UIColor whiteColor] ;
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.indicatorImgView.alpha = 0.0;
//            [self sendSubviewToBack:self.imgIcon];
//            self.lineView.backgroundColor = [UIColor redColor];
        }else if ([THEMEV3 isEqualToString:@"black"]){
            self.labTitle.textColor = colorWithRGB(22, 141, 246) ;
//            self.lineView.backgroundColor = colorWithRGB(22, 141, 246);
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.indicatorImgView.alpha = 0.0;
//            [self bringSubviewToFront:self.imgIcon];
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Blue ;
            //            self.lineView.backgroundColor = colorWithRGB(22, 141, 246);
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.indicatorImgView.alpha = 0.0;
//            [self bringSubviewToFront:self.imgIcon];
            self.labTitle.textColor = [UIColor whiteColor] ;
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Orange ;
            //            self.lineView.backgroundColor = colorWithRGB(22, 141, 246);
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.indicatorImgView.alpha = 0.0;
            //            [self bringSubviewToFront:self.imgIcon];
            self.labTitle.textColor = [UIColor whiteColor] ;
        }else if ([THEMEV3 isEqualToString:@"default"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor ;
            //            self.lineView.backgroundColor = colorWithRGB(22, 141, 246);
            [self bringSubviewToFront:self.imgIcon];
            self.labTitle.textColor = [UIColor blackColor] ;
            [self bringSubviewToFront:self.indicatorImgView];
            self.indicatorImgView.alpha = 1.0;
        }else if ([THEMEV3 isEqualToString:@"red_white"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Red_White ;
            self.indicatorImgView.alpha = 1.0;
        }else if ([THEMEV3 isEqualToString:@"green_white"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Green_White ;
            self.indicatorImgView.alpha = 1.0;
        }else if ([THEMEV3 isEqualToString:@"orange_white"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            self.indicatorImgView.alpha = 1.0;
        }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            self.indicatorImgView.alpha = 1.0;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            //            self.lineView.backgroundColor = colorWithRGB(22, 141, 246);
            self.imageB.image = ImageWithName(@"nav-hover-black-bg");
            self.indicatorImgView.alpha = 0.0;
            //            [self bringSubviewToFront:self.imgIcon];
            self.labTitle.textColor = [UIColor whiteColor] ;
        }else{
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor ;
            self.indicatorImgView.alpha = 1.0;
        }
    }else {
        [self.imageB removeFromSuperview];
        self.imageB.image = nil;
        
        [self.lineView removeFromSuperview] ;
        self.lineView = nil ;
//        self.labTitle.textColor = [UIColor blackColor] ;
        if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
            self.labTitle.textColor = [UIColor whiteColor] ;
        }else{
            self.labTitle.textColor = [UIColor blackColor] ;
        }
    }
}

-(void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO] ;
}


-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.lotteryCategoryModel = ConvertToClassPointer(RH_LotteryCategoryModel, context) ;
    self.labTitle.text = self.lotteryCategoryModel.mApiTypeName ;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.lotteryCategoryModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    NSLog(@"--%@",self.lotteryCategoryModel.showCover);
}

@end
