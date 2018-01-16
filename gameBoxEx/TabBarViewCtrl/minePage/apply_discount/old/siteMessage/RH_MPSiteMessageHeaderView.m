//
//  RH_MPSiteMessageHeaderView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageHeaderView.h"
#import "coreLib.h"
@implementation RH_MPSiteMessageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateSelected];
}
- (IBAction)deleteChooseOnCell:(id)sender {
    ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewDeleteCell:)){
        [self.delegate siteMessageHeaderViewDeleteCell:self] ;
    }
}
- (IBAction)allChoseBtnClick:(id)sender {
//    [self.delegate siteMessageHeaderViewAllChoseBtn:self];
}

@end
