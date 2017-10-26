//
//  CLLabel.m
//  TaskTracking
//
//  Created by jinguihua on 2017/5/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLLabel.h"

@implementation CLLabel

#pragma mark - coding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.intrinsicSizeExpansionLength = [aDecoder decodeCGSizeForKey:@"intrinsicSizeExpansionLength"];
        self.intrinsicSizeExpansionScale = [aDecoder decodeCGSizeForKey:@"intrinsicSizeExpansionScale"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeCGSize:self.intrinsicSizeExpansionLength forKey:@"intrinsicSizeExpansionLength"];
    [aCoder encodeCGSize:self.intrinsicSizeExpansionLength forKey:@"intrinsicSizeExpansionScale"];
}


#pragma mark -


- (void)setIntrinsicSizeExpansionLength:(CGSize)intrinsicSizeExpansionLength
{
    if (!CGSizeEqualToSize(_intrinsicSizeExpansionLength, intrinsicSizeExpansionLength)) {
        _intrinsicSizeExpansionLength = intrinsicSizeExpansionLength;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setIntrinsicSizeExpansionScale:(CGSize)intrinsicSizeExpansionScale
{
    if (!CGSizeEqualToSize(_intrinsicSizeExpansionScale, intrinsicSizeExpansionScale)) {
        _intrinsicSizeExpansionScale = intrinsicSizeExpansionScale;
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = [super intrinsicContentSize];

    intrinsicContentSize.width *= (1.f + self.intrinsicSizeExpansionScale.width);
    intrinsicContentSize.width += self.intrinsicSizeExpansionLength.width;

    intrinsicContentSize.height *= (1.f + self.intrinsicSizeExpansionScale.width);
    intrinsicContentSize.height += self.intrinsicSizeExpansionLength.height;

    return intrinsicContentSize;

}


@end
