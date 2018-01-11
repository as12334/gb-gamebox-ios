//
//  RH_MPGameNoticSectionView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticHeaderView.h"
#import "RH_MPGameSeletedDateView.h"
#import "coreLib.h"
@interface RH_MPGameNoticHeaderView()
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *startSeletedDateView ;
@property (weak, nonatomic) IBOutlet UIView *startDateView;
@property (weak, nonatomic) IBOutlet UIView *ennDateView;
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *endSeletedDateView ;
@end

@implementation RH_MPGameNoticHeaderView
@synthesize startSeletedDateView = _startSeletedDateView;
@synthesize endSeletedDateView = _endSeletedDateView;
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(RH_MPGameSeletedDateView *)startSeletedDateView
{
    if (!_startSeletedDateView) {
        _startSeletedDateView = [[RH_MPGameSeletedDateView alloc]initWithFrame:self.startDateView.bounds];
        [_startSeletedDateView addTarget:self Selector:@selector(startDateHandle)];
    }
    return _startSeletedDateView;
}
-(RH_MPGameSeletedDateView *)endSeletedDateView
{
    if (!_endSeletedDateView) {
        _endSeletedDateView = [[RH_MPGameSeletedDateView alloc]initWithFrame:self.ennDateView.bounds];
        [_endSeletedDateView addTarget:self Selector:@selector(endDateHandle)];
    }
    return _endSeletedDateView;
}
-(void)startDateHandle
{
    
}
-(void)endDateHandle
{
    
}
@end
