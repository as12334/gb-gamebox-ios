//
//  CLGradientView.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLGradientView.h"

@implementation CLGradientView
#pragma mark - life circle

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self _init_GradientView];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init_GradientView];
    }

    return self;
}

- (void)_init_GradientView {
    self.backgroundColor = [UIColor clearColor];
}


#define _gradientLayer ((CAGradientLayer *)self.layer)

#define LAYER_ACCESSOR(accessor, ctype) \
- (ctype)accessor {                     \
return [_gradientLayer accessor];   \
}

#define LAYER_MUTATOR(mutator, ctype)   \
- (void)mutator (ctype)value {          \
[_gradientLayer mutator value];     \
}

#define LAYER_RW_PROPERTY(accessor, mutator, ctype) \
LAYER_ACCESSOR (accessor, ctype)                \
LAYER_MUTATOR (mutator, ctype)

LAYER_RW_PROPERTY(startPoint, setStartPoint:, CGPoint)
LAYER_RW_PROPERTY(endPoint, setEndPoint:, CGPoint)
LAYER_RW_PROPERTY(locations, setLocations:, NSArray *)


- (void)setColors:(NSArray *)colors
{
    NSMutableArray * cgColors = [NSMutableArray arrayWithCapacity:colors.count];

    for (UIColor * color in colors) {
        if ([color respondsToSelector:@selector(CGColor)]) {
            [cgColors addObject:(__bridge id)[color CGColor]];
        }
    }

    _gradientLayer.colors = cgColors;
}

- (NSArray *)colors
{
    NSArray * cgColors = _gradientLayer.colors;

    NSMutableArray * colors = [NSMutableArray arrayWithCapacity:cgColors.count];
    for (id cgColor in cgColors) {
        [colors addObject:[UIColor colorWithCGColor:(__bridge CGColorRef)cgColor]];
    }

    return colors;
}


@end
