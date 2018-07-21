//
//  RH_ChangePswSuccessView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ChangePswSuccessView.h"
#import "MacroDef.h"
#import "RH_FBPChangePwView.h"

@interface RH_ChangePswSuccessView ()
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@end

@implementation RH_ChangePswSuccessView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cornerView.layer.cornerRadius = 10;
    self.cornerView.clipsToBounds = YES;
}

- (IBAction)close:(id)sender
{
   
        ifRespondsSelector(self.delegate, @selector(changePswSuccessViewClose:))
        {
            [self.delegate changePswSuccessViewClose:self];
        }
    
    
   
}


@end
