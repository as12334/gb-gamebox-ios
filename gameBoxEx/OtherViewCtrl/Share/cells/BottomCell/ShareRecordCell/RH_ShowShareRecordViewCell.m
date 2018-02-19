//
//  RH_ShowShareRecordViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShowShareRecordViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"

@implementation RH_ShowShareRecordViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *topView = [[UIView alloc] init];
        [self.contentView addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor] ;
        topView.whc_TopSpace(0).whc_RightSpace(10).whc_LeftSpace(10).whc_Height(35);
        
        for (int i = 0; i<4; i++) {
            UILabel *titleLba = [[UILabel alloc] init];
            titleLba.frame = CGRectMake(self.frame.size.width/4.0*i, 0, self.frame.size.width/4.0, 35.0);
            titleLba.tag = 100+i;
            titleLba.textColor = colorWithRGB(68, 68, 68) ;
            titleLba.font = [UIFont systemFontOfSize:14.f] ;
            titleLba.textAlignment = NSTextAlignmentCenter ;
            UILabel *lineLab = [[UILabel alloc] init];
            lineLab.frame = CGRectMake(self.frame.size.width/4.0*i, 0, 1, 35);
            lineLab.backgroundColor = [UIColor whiteColor] ;
            [topView addSubview:lineLab] ;
            [topView addSubview:titleLba];
        }
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *recommendModel = ConvertToClassPointer(RH_SharePlayerRecommendModel, context) ;
    
    for (int i = 100; i<104; i++) {
        UILabel *lab = [self.contentView viewWithTag:i];
        switch (i) {
            case 100:
                lab.text = @"123" ;
                break;
            case 101:
                lab.text = @"111" ;
                break ;
            case 102:
                lab.text = @"121" ;
                break ;
            case 103:
                lab.text = @"131" ;
                break ;
            default:
                break;
        }
    }
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
