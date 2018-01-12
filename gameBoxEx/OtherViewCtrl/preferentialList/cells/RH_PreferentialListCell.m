//
//  RH_PreferentialListCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PreferentialListCell.h"
#import "coreLib.h"
@implementation RH_PreferentialListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.label_Title.whc_TopSpace(5).whc_LeftSpaceEqualViewOffset(self.image_Right, 20).whc_Height(20).whc_Width(200);
    self.label_Bottom.whc_BottomSpace(5).whc_LeftSpaceEqualView(self.label_Title).whc_Height(15).whc_Width(120);
    self.label_Time.whc_BottomSpace(5).whc_CenterX(0).whc_Height(20).whc_Width(200);
    self.label_RightMoney.whc_TopSpace(10).whc_RightSpace(40).whc_Width(60).whc_Height(30);
    self.label_Grant.whc_CenterToView(CGPointMake(0, 30), self.label_RightMoney);
    
    self.label_Title.textColor = colorWithRGB(68, 68, 68);
    self.label_Title.font = [UIFont systemFontOfSize:14];
    self.label_Bottom.textColor = colorWithRGB(153, 153, 153);
    self.label_Bottom.font = [UIFont systemFontOfSize:12];
    self.label_Time.font = [UIFont systemFontOfSize:12];
    self.label_Time.textColor = colorWithRGB(153, 153, 153);
    self.label_RightMoney.font = [UIFont systemFontOfSize:17];
    self.label_RightMoney.textColor = colorWithRGB(255, 255, 255);
    self.label_Grant.font = [UIFont systemFontOfSize:14];
    self.label_Grant.textColor = colorWithRGB(255, 255, 255);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellGranted:(PreferentialListCellBackType)grant {
    switch (grant) {
        case PreferentialListCellBackTypeDidGrant:
            [self.image_Right setImage:ImageWithName(@"mine_preferentialbackorange")];
            self.label_Grant.text = @"已发放";
            break;
            case PreferentialListCellBackTypeNotGrant:
            [self.image_Right setImage:ImageWithName(@"mine_preferentialbackgreen")];
            self.label_Grant.text = @"已审核";
            break;
            case PreferentialListCellBackTypePermitting:
            [self.image_Right setImage:ImageWithName(@"mine_preferentialbackgray")];
            self.label_Grant.text = @"待审核";
            break;
        default:
            break;
    }
}

@end
