//
//  RH_SureLeaveApiView.m
//  gameBoxEx
//
//  Created by sam on 2018/10/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SureLeaveApiView.h"
#import "coreLib.h"
@interface RH_SureLeaveApiView()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
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
    
    self.bgView.layer.cornerRadius = 5.0;
    self.bgView.clipsToBounds = YES;
    
    self.topView.layer.cornerRadius = 31.5;
    self.topView.clipsToBounds = YES;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.topView.layer.borderWidth = 1.0;
}

- (IBAction)cancerAction:(id)sender {
    [self removeFromSuperview];
    ifRespondsSelector(self.delegate, @selector(cancelLeaveApiViewDelegate)){
        [self.delegate cancelLeaveApiViewDelegate];
    }
}

- (IBAction)sureAction:(id)sender {
    [self removeFromSuperview];
    ifRespondsSelector(self.delegate, @selector(sureLeaveApiViewDelegate)){
        [self.delegate sureLeaveApiViewDelegate];
    }
}

@end
