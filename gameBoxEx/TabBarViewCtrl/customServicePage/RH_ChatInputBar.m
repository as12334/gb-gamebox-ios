//
//  RH_ChatInputBar.m
//  gameBoxEx
//
//  Created by luis on 2017/10/18.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_ChatInputBar.h"
#import "MacroDef.h"

@interface RH_ChatInputBar()<UITextViewDelegate>
@end

@implementation RH_ChatInputBar
@synthesize textView = _textView ;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _textView  =  [[UITextView alloc] initWithFrame:CGRectZero textContainer:nil] ;
        _textView.font          = [UIFont systemFontOfSize:16];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate      = (id)self;
        _textView.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _textView.layer.borderWidth     = 1;
        _textView.layer.cornerRadius    = 4;
        _textView.backgroundColor = [UIColor lightGrayColor] ;
        _textView.translatesAutoresizingMaskIntoConstraints = NO ;
        _textView.delegate = self ;
        [self addSubview:self.textView];
        setAllEdgeConstraint(_textView, self, 5.0f) ;

        //增加keyboard event

    }
    return self;
}

#pragma mark-keyboard observer
/** 更新frame */
- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
}

#pragma mark-
-(void)textViewDidChange:(UITextView *)textView{
    ifRespondsSelector(self.delegate, @selector(ChatInputBarInputTextDidChanged:)){
        [self.delegate ChatInputBarInputTextDidChanged:self] ;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder] ;
        ifRespondsSelector(self.delegate, @selector(ChatInputBarInputTextTouchSend:)){
            [self.delegate ChatInputBarInputTextTouchSend:self] ;
        }
        return NO;
    }

    return YES;
}

@end
