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
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
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
        self.lineView.backgroundColor = colorWithRGB(226, 226, 226);
        
        if ([THEMEV3 isEqualToString:@"green"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Green ;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Red ;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor_Black ;
        }else{
            self.labTitle.textColor = RH_NavigationBar_BackgroundColor ;
        }
    }else {
        [self.imageB removeFromSuperview];
        self.imageB.image = nil;
        
        [self.lineView removeFromSuperview] ;
        self.lineView = nil ;
        self.labTitle.textColor = RH_Label_DefaultTextColor ;
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
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.lotteryCategoryModel.showCover]] ;
}

@end
