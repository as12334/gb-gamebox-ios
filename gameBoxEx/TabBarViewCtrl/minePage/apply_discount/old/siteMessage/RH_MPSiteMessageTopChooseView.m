//
//  RH_MPSiteMessageTopChooseView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageTopChooseView.h"
@interface RH_MPSiteMessageTopChooseView()
@property (weak, nonatomic) IBOutlet UIButton *inceptionBtn;
@property(nonatomic,strong)UIButton *isSelectedBtn;
@end
@implementation RH_MPSiteMessageTopChooseView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIButton *btn = [self viewWithTag:10];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.selected = !btn.selected;
        self.isSelectedBtn = btn;
    }
    return self;
}
- (IBAction)chooseEachNoticeBtn:(id)sender {
    UIButton *btn = sender;
    if (!btn.isSelected) {
        self.isSelectedBtn.selected = !self.isSelectedBtn.selected;
        self.isSelectedBtn.backgroundColor = [UIColor lightGrayColor];
        [self.isSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.selected = !btn.selected;
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.isSelectedBtn = btn;
    }

}

@end
