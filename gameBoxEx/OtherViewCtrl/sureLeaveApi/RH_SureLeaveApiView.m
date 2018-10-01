//
//  RH_SureLeaveApiView.m
//  gameBoxEx
//
//  Created by sam on 2018/10/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SureLeaveApiView.h"
@interface RH_SureLeaveApiView()
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation RH_SureLeaveApiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    self.topView.layer.cornerRadius = 31.5;
    self.topView.clipsToBounds = YES;
}

- (IBAction)cancerAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    
}

@end
