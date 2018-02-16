//
//  RH_SmallHeadView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SmallHeadView.h"
#import "coreLib.h"

@implementation RH_SmallHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *bgVie = [[UIView alloc] init];
        [self addSubview:bgVie];
        bgVie.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
        bgVie.backgroundColor = colorWithRGB(228, 247, 231) ;
        bgVie.layer.borderWidth = 1.f ;
        bgVie.layer.borderColor = [UIColor whiteColor].CGColor ;
        NSArray *titleArr = @[@"好友账号",@"有效投注",@"红利",@"互惠奖励"] ;
        for (int i = 0; i<titleArr.count; i++) {
            UILabel *titleLba = [[UILabel alloc] init];
            titleLba.frame = CGRectMake(self.frame.size.width/4.0*i, 0, self.frame.size.width/4.0, 35.0);
            titleLba.text = titleArr[i];
            titleLba.textColor = colorWithRGB(68, 68, 68) ;
            titleLba.font = [UIFont systemFontOfSize:14.f] ;
            titleLba.textAlignment = NSTextAlignmentCenter ;
            UILabel *lineLab = [[UILabel alloc] init];
            lineLab.frame = CGRectMake(self.frame.size.width/4.0*(i+1), 0, 1, 35);
            lineLab.backgroundColor = [UIColor whiteColor] ;
            [bgVie addSubview:titleLba];
            [bgVie addSubview:lineLab] ;
        }
    }
    return self ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
