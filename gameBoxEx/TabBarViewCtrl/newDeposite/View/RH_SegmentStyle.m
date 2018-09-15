//
//  RH_SegmentStyle.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SegmentStyle.h"
@implementation RH_SegmentStyle
- (instancetype)init {
    if(self = [super init]) {
        self.showCover = NO;
        self.showLine = YES;
        self.scaleTitle = NO;
        self.scrollTitle = YES;
        self.segmentViewBounces = YES;
        self.gradualChangeTitleColor = NO;
        self.showExtraButton = NO;
        self.scrollContentView = YES;
        self.adjustCoverOrLineWidth = NO;
        self.extraBtnBackgroundImageName = nil;
        self.scrollLineHeight = 2.0;
        self.scrollLineColor = [UIColor redColor];
        self.coverBackgroundColor = [UIColor lightGrayColor];
        self.coverCornerRadius = 14.0;
        self.coverHeight = 28.0;
        self.titleMargin = 20.0;
        self.titleFont = [UIFont systemFontOfSize:12.0];
        self.titleBigScale = 13/12.0;
        self.normalTitleColor = [UIColor colorWithRed:185/255.0 green:172/255.0 blue:176/255.0 alpha:1];
        
        self.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:82/255.0 blue:82/255.0 alpha:1];
        
        self.segmentHeight = 40.0;
        
    }
    return self;
}
@end
