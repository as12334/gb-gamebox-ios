//
//  RH_SiteSendMessageView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteSendMessageView.h"
@interface RH_SiteSendMessageView()
@property (weak, nonatomic) IBOutlet UIView *backDropView;

@end
@implementation RH_SiteSendMessageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backDropView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backDropView.layer.borderWidth = 1.f;
    self.backDropView.layer.masksToBounds = YES;
}
- (IBAction)favorableSelectedClick:(id)sender {
    UIButton *btn  =sender;
    self.block(btn.frame);
}
@end
