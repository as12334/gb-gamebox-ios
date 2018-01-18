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

//向下指示图
@property (nonatomic,strong) IBOutlet UIImageView *indicatorImgView ;

@end

@implementation RH_HomeCategorySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:12.0f]    ;
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
    self.imgIcon.whc_TopSpace(4).whc_CenterX(0).whc_Width(25).whc_Height(25);
    self.selectionOption = CLSelectionOptionNone ;
    self.borderMask = CLBorderMarkNone ;
    self.borderView.borderColor = RH_Line_DefaultColor ;
    self.indicatorImgView.hidden = YES ;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated] ;
    self.indicatorImgView.hidden = !selected ;
    self.borderView.borderMask = selected?CLBorderMarkBottom:CLBorderMarkNone ;
    self.borderView.backgroundColor = selected?[UIColor whiteColor]:[UIColor clearColor] ;
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
