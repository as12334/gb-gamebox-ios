//
//  CLTextField.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLTextField.h"

@implementation CLTextField
@synthesize placeholderColor=_placeholderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height-self.font.pointSize)/2, rect.size.width, self.frame.size.height-(rect.size.height-self.font.pointSize)/2);

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = self.textAlignment;

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, self.font, NSFontAttributeName, self.placeholderColor, NSForegroundColorAttributeName, nil];

        [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
    }
    else {
        [self.placeholderColor setFill];
//        [self.placeholder drawInRect:rect withFont:self.font];
        [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName:self.font}] ;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}


@end
