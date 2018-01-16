//
//  RH_MPSiteMessageHeaderView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageHeaderView.h"
#import "coreLib.h"
@interface RH_MPSiteMessageHeaderView()
@property (nonatomic,assign)BOOL choceMark;
@end
@implementation RH_MPSiteMessageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.choceMark=YES;
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.choceMark==YES) {
        [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    else if (self.choceMark ==NO){
    [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    }
}
- (IBAction)deleteChooseOnCell:(id)sender {
    ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewDeleteCell:)){
        [self.delegate siteMessageHeaderViewDeleteCell:self] ;
    }
}
- (IBAction)markReadClick:(id)sender {
    ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewReadBtn:)){
        [self.delegate siteMessageHeaderViewReadBtn:self] ;
    }
}
- (IBAction)allChoseBtnClick:(id)sender {
    if (self.choceMark==YES) {
        ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewAllChoseBtn:)){
            [self.delegate siteMessageHeaderViewAllChoseBtn:self.choceMark];
        }
         [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.choceMark=NO;
    }
    else if (self.choceMark==NO){
        ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewAllChoseBtn:)){
            [self.delegate siteMessageHeaderViewAllChoseBtn:self.choceMark];
        }
         [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.choceMark=YES;
    }
    
}

@end
