//
//  CLContentTextInputView.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/23.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLContentTextInputView.h"
#import "CLTextView.h"
#import "MacroDef.h"

@interface CLContentTextInputView ()<UITextViewDelegate>
@property (nonatomic,strong) CLTextView *myTextView;
@end

@implementation CLContentTextInputView
{
    BOOL _ignoreValueChange;
}

@synthesize myTextView = _myTextView;

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self _commenInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commenInit];
    }

    return self;
}

- (void)_commenInit
{
    //    self.backgroundColor = [UIColor blueColor];
    self.myTextView.font = [UIFont systemFontOfSize:12.0] ;
    self.myTextView = [[CLTextView alloc] initWithFrame:self.bounds];
    self.myTextView.textContainerInset = UIEdgeInsetsMake(15.f, 15.f, 0.f, 15.f);
    self.myTextView.delegate = self;
    self.myTextView.backgroundColor = [UIColor clearColor] ;
    [self addSubview:self.myTextView];

    self.myTextView.typingAttributes = @{NSForegroundColorAttributeName : ColorWithNumberRGB(0x303030),NSFontAttributeName : [UIFont systemFontOfSize:16.f]};

    self.myTextView.translatesAutoresizingMaskIntoConstraints = NO;
    setAllEdgeConstraint(self.myTextView, self, 0.f);

}

#pragma mark -

-(BOOL)isEditting{
    return self.myTextView.isFirstResponder;
}

-(void)setEditting:(BOOL)editting{
    if (editting) {
        [self.myTextView becomeFirstResponder];
    }else{
        [self.myTextView resignFirstResponder];
    }
}

- (void)setText:(NSString *)text
{
    if (text.length == 0) {
//        self.myTextView.attributedText = nil;
        self.myTextView.text = nil ;
    }else {

//        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:text];
//        self.myTextView.attributedText = attributedText;
        self.myTextView.text = text ;
    }

    [self _updateTextViewLimit];
}

- (NSString *)text {
    return self.myTextView.text;
}

- (NSAttributedString *)attributedText {
    return self.myTextView.attributedText;
}

-(NSString*)placeHolderText
{
    return self.myTextView.placeholderText ;
}

-(void)setPlaceHolderText:(NSString *)placeHolderText
{
    if ([self.myTextView.placeholderText isEqualToString:placeHolderText]==false){
        self.myTextView.placeholderText = placeHolderText ;
        self.myTextView.placeholderAttributed = @{NSFontAttributeName : [UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName : ColorWithNumberRGB(0xBDBDBD)};
    }
}

#pragma mark -


- (NSAttributedString *)_attributedTextWithContentText:(NSString *)text
{
    if (text.length == 0) {
        return nil;
    }

    return [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : ColorWithNumberRGB(0x303030),NSFontAttributeName : [UIFont systemFontOfSize:16.f]}];
}


-(void)_updateTextViewLimit
{
    id<CLContentTextInputViewDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(contentTextInputView:withTextLength:)){
        [delegate contentTextInputView:self withTextLength:self.myTextView.attributedText.length];
    }
}

#pragma mark -

-(void)textViewDidChange:(UITextView *)textView{
    [self _updateTextViewLimit];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.typingAttributes = @{NSForegroundColorAttributeName : ColorWithNumberRGB(0x303030),NSFontAttributeName : [UIFont systemFontOfSize:16.f]};
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    ifRespondsSelector(self.delegate, @selector(contentTextInputViewDidEndEditing:)){
        [self.delegate contentTextInputViewDidEndEditing:self] ;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (_ignoreValueChange) {
        return;
    }

    /*
    NSRange selectedRange = textView.selectedRange;
    NSRange atRange = [self _atRangeForLocationRange:selectedRange];

    if (atRange.location != NSNotFound &&
        selectedRange.location <= (atRange.location + atRange.length) &&
        (selectedRange.location + atRange.length) >= atRange.location) {
        _ignoreValueChange = YES;
        textView.selectedRange = atRange;
        _ignoreValueChange = NO;
    }
     */
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    textView.typingAttributes = @{NSForegroundColorAttributeName : ColorWithNumberRGB(0x303030),NSFontAttributeName : [UIFont systemFontOfSize:16.f]};

    /*
    if (text.length == 0) {
        NSRange atRange = [self _atRangeForLocationRange:range];
        if (atRange.location != NSNotFound && ! NSEqualRanges(atRange, range)) {

            NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
            [text replaceCharactersInRange:atRange withString:@""];
            textView.attributedText = text;
            textView.selectedRange = NSMakeRange(atRange.location, 0);

            [self _updateTextViewLimit];
            return NO;
        }
    }
    */
    return YES;
}

@end
