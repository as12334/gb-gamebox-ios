//
//  RH_FindbackPswWaysView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FindbackPswWayView.h"
#import "MacroDef.h"

@interface RH_FindbackPswWayView ()
@property (weak, nonatomic) IBOutlet UIButton *bindBt;

@end

@implementation RH_FindbackPswWayView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bindBt.layer.cornerRadius = 4;
    self.bindBt.clipsToBounds = YES;
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.bindBt setBackgroundColor:_themeColor];
}

- (IBAction)findbackByPhone:(id)sender {
    ifRespondsSelector(self.delegate, @selector(findbackPswWayViewFindByPhone:)){
        [self.delegate findbackPswWayViewFindByPhone:self];
    }
}

- (IBAction)findbackByCus:(id)sender {
    ifRespondsSelector(self.delegate, @selector(findbackPswWayViewFindByCust:)){
        [self.delegate findbackPswWayViewFindByCust:self];
    }
}

- (IBAction)bindPhoneAction:(id)sender {
    ifRespondsSelector(self.delegate, @selector(findbackPswWayViewBindPhone:)){
        [self.delegate findbackPswWayViewBindPhone:self];
    }
}

@end
