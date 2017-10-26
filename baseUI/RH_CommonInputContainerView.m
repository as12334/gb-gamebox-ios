//
//  RH_CommonInputContainerView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/27.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_CommonInputContainerView.h"
#import "coreLib.h"

@implementation RH_CommonInputContainerView

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    if (self.textField) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_textFieldDidChangeEditStatus:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_textFieldDidChangeEditStatus:)
                                                     name:UITextFieldTextDidEndEditingNotification
                                                   object:self.textField];

        if (self.type == RH_CommonInputContainerViewTypeLine) {
            self.borderMask = CLBorderMarkBottom;
            self.borderColor = [UIColor whiteColor];
        }else{
            self.layer.cornerRadius = 5.f;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
        }

        [self _textFieldDidChangeEditStatus:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_textFieldDidChangeEditStatus:(NSNotification *)notification
{
    if ([self.textField isFirstResponder]) {

        if (self.type == RH_CommonInputContainerViewTypeLine) {
            self.borderWidth = 1.f;
        }else{
            self.layer.borderWidth = 1.f;
        }

        self.alpha = 1.f;

    }else{

        if (self.type == RH_CommonInputContainerViewTypeLine) {
            self.borderWidth = PixelToPoint(1.f);
        }else{
            self.layer.borderWidth = PixelToPoint(1.f);
        }

        self.alpha = 0.5f;
    }

    if (self.textFieldDidChangeEditStatusBlock) {
        self.textFieldDidChangeEditStatusBlock([self.textField isFirstResponder]);
    }
}


@end
