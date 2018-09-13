//
//  CustomPageControl.m
//  gameBoxEx
//
//  Created by sam on 2018/9/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    return self;
    
}

-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = (UIImageView *)[self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 7;     //自定义圆点的大小
        size.width = 25;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.height)];
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

@end
