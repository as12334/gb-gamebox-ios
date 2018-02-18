//
//  RH_SmallShareTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SmallShareTableViewCell.h"
#import "coreLib.h"

@implementation RH_SmallShareTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.friendAccountNumLab = [[UILabel alloc] init];
        self.bettingCountLab = [[UILabel alloc] init];
        self.bonusLab = [[UILabel alloc] init ];
        self.rewardLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.friendAccountNumLab];
        [self.contentView addSubview:self.bettingCountLab];
        [self.contentView addSubview:self.bonusLab];
        [self.contentView addSubview:self.rewardLab];
        CGFloat sizeWidth = self.contentView.frame.size.width/4.0 ;
        self.friendAccountNumLab.whc_LeftSpace(0).whc_TopSpace(0).whc_Width(sizeWidth).whc_BottomSpace(0);
        self.bettingCountLab.whc_LeftSpaceToView(0, self.friendAccountNumLab).whc_TopSpace(0).whc_Width(sizeWidth).whc_BottomSpace(0);
        self.bonusLab.whc_LeftSpaceToView(0, self.bettingCountLab).whc_TopSpace(0).whc_Width(sizeWidth).whc_BottomSpace(0);
        self.rewardLab.whc_LeftSpaceToView(0, self.bonusLab).whc_TopSpace(0).whc_Width(sizeWidth).whc_BottomSpace(0);
        self.friendAccountNumLab.textColor = colorWithRGB(68, 68, 68) ;
        self.friendAccountNumLab.font = [UIFont systemFontOfSize:12.f] ;
        self.friendAccountNumLab.textAlignment = NSTextAlignmentCenter ;
        self.friendAccountNumLab.text = @"abc**123";
        
        self.bettingCountLab.textColor = colorWithRGB(68, 68, 68) ;
        self.bettingCountLab.font = [UIFont systemFontOfSize:12.f] ;
        self.bettingCountLab.textAlignment = NSTextAlignmentCenter ;
        self.bettingCountLab.text = @"12345";
        
        self.bonusLab.textColor = colorWithRGB(68, 68, 68) ;
        self.bonusLab.font = [UIFont systemFontOfSize:12.f] ;
        self.bonusLab.textAlignment = NSTextAlignmentCenter ;
        self.bonusLab.text =@"88";
        
        self.rewardLab.textColor = colorWithRGB(68, 68, 68) ;
        self.rewardLab.font = [UIFont systemFontOfSize:12.f] ;
        self.rewardLab.textAlignment = NSTextAlignmentCenter ;
        self.rewardLab.text = @"已获得";
        
        
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
