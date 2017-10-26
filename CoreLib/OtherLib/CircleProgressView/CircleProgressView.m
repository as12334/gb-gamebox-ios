//
//  CircleProgressView.m
//  CircleProgress
//
//  Created by ln on 15/8/4.
//  Copyright (c) 2015年 xcgdb. All rights reserved.
//

#import "CircleProgressView.h"
#import "MacroDef.h"

@interface CircleProgressView()
@property (nonatomic,strong,readonly) CAShapeLayer *shapeLayer;
@end


@implementation CircleProgressView
@synthesize lineWitdh = _lineWitdh,startValue = _startValue,changeValue = _changeValue,lineColor = _lineColor;
@synthesize shapeLayer = _shapeLayer ;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInfo] ;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder] ;
    if (self) {
        [self setupInfo] ;
    }
    return self;
}

-(CAShapeLayer*)shapeLayer
{
    if (!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.lineWidth = self.lineWitdh;
        _shapeLayer.strokeColor = self.lineColor.CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 0;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;

        UIBezierPath *bezirPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        _shapeLayer.path = bezirPath.CGPath;
    }

    return _shapeLayer ;
}

-(instancetype)init
{
    self = [super init] ;
    if (self) {
        [self setupInfo] ;
    }
    return self;
}

-(void)setupInfo
{
    self.backgroundColor = [UIColor clearColor] ;
    //define value
    _lineWitdh = 2.0 ;
    _startValue = 0.0 ;
    _changeValue = 0.0 ;
    _lineColor = ColorWithNumberRGBA(0x17a4e2, 1) ;

    [self.layer addSublayer:self.shapeLayer] ;
    [self initProgressText];
//    [self _registerForKVO] ;
}

-(void)dealloc{
//    [self _unregisterFromKVO] ;
}

//#pragma mark- KVO
//- (void)_registerForKVO
//{
//    for (NSString *keyPath in [self _observableKeypaths]) {
//        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
//    }
//}
//
//- (void)_unregisterFromKVO
//{
//    for (NSString *keyPath in [self _observableKeypaths]) {
//        [self removeObserver:self forKeyPath:keyPath];
//    }
//}
//
//- (NSArray *)_observableKeypaths {
//    return @[@"bounds"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (self == object &&![change[@"old"] isEqual:change[@"new"]]) {
//        [self setNeedsLayout] ;
//    }
//}
//
//- (void)_updateUIForKeypath:(NSString *)keyPath {
//    [self setNeedsLayout];
//}
//
#pragma mark 重写set、get方法

-(void)setLineWitdh:(CGFloat)lineWitdh{
    if (_lineWitdh!=lineWitdh){
        _lineWitdh = lineWitdh;
        self.shapeLayer.lineWidth = lineWitdh;
    }
}
-(CGFloat)lineWitdh{
    return _lineWitdh;
}

-(void)setLineColor:(UIColor *)lineColor{
    if (_lineColor!=lineColor){
        _lineColor = lineColor;
        self.shapeLayer.strokeColor = lineColor.CGColor;
    }
}
-(UIColor *)lineColor{
    return _lineColor;
}

-(void)setStartValue:(CGFloat)startValue{
    if (startValue!=_startValue){
        _startValue = startValue;
        self.shapeLayer.strokeEnd = startValue;
    }
}
-(CGFloat)startValue{
    return _startValue;
}


-(void)setChangeValue:(CGFloat)changeValue{
    if (_changeValue!=changeValue){
        _changeValue = changeValue;
        self.shapeLayer.strokeEnd = changeValue;
    }
}
-(CGFloat)changeValue{
    return _changeValue;
}

-(void)initProgressText{
    _progressText = [UILabel new];
    _progressText.translatesAutoresizingMaskIntoConstraints = NO;
    _progressText.textAlignment = NSTextAlignmentCenter;
    _progressText.adjustsFontSizeToFitWidth = YES;
    _progressText.font = [UIFont systemFontOfSize:11];
    _progressText.textColor = ColorWithNumberRGB(0x3984db) ;
    [self addSubview:_progressText];


    NSDictionary *views = NSDictionaryOfVariableBindings(_progressText);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_progressText]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_progressText]-2-|" options:0 metrics:nil views:views]];
}

#pragma mark-


@end

