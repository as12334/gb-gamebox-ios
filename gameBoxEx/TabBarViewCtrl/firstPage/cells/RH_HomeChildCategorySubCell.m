//
//  RH_HomeChildCategorySubCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeChildCategorySubCell.h"
#import "coreLib.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_HomeChildCategorySubCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet CLBorderView *borderView ;
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) RH_LotteryAPIInfoModel *lotteryApiModel ;

@end

@implementation RH_HomeChildCategorySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f]    ;
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
    
    self.selectionOption = CLSelectionOptionNone ;
    self.borderMask = CLBorderMarkNone ;
    self.borderView.borderColor = [UIColor blueColor] ;

}

//-(void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated] ;
//    self.borderView.borderMask = selected?CLBorderMarkBottom:CLBorderMarkNone ;
//}

-(void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO] ;
}


-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.lotteryApiModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, context) ;
    self.labTitle.text = self.lotteryApiModel.mName ;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.lotteryApiModel.showCover]] ;
}

@end
