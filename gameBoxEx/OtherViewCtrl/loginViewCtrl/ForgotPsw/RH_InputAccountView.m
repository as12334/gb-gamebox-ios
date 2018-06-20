//
//  RH_InputAccountView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_InputAccountView.h"
#import "MacroDef.h"

@interface RH_InputAccountView()
@property (weak, nonatomic) IBOutlet UITextField *accInputTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@end

@implementation RH_InputAccountView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nextBt.layer.cornerRadius = 4;
    self.nextBt.clipsToBounds = YES;
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.nextBt setBackgroundColor:_themeColor];
}

- (IBAction)nextAction:(id)sender {
    ifRespondsSelector(self.delegate, @selector(inputAccountView:next:))
    {
        [self.delegate inputAccountView:self next:self.accInputTF.text];
    }
}

@end
