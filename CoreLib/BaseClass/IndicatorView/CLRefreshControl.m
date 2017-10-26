//
//  CLRefreshControl.m
//  CoreLib
//
//  Created by jinguihua on 2017/1/20.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLRefreshControl.h"
#import "CLActivityIndicatorView.h"
#import "help.h"
#import "MacroDef.h"

//----------------------------------------------------------

@interface CLRefreshControl ()

@property(nonatomic,strong,readonly) NSMutableDictionary * textDictionary;

@property(nonatomic,strong,readonly) UILabel * titleLabel;

//箭头风格
@property(nonatomic,strong,readonly) UIImageView * arrowImage;
@property(nonatomic,strong,readonly) UIActivityIndicatorView * sysActivityIndicatorView;

//进度风格
@property(nonatomic,strong,readonly) CLActivityIndicatorView * activityIndicatorView;

@end

//----------------------------------------------------------

@implementation CLRefreshControl

@synthesize textDictionary = _textDictionary;
@synthesize titleLabel = _titleLabel;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize arrowImage = _arrowImage;
@synthesize sysActivityIndicatorView = _sysActivityIndicatorView;

- (id)initWithLocation:(CLScrollTriggerViewLocation)location minTriggerDistance:(CGFloat)minTriggerDistance
{
    return [self initWithType:location == CLScrollTriggerViewLocationBottom ? CLRefreshControlTypeBottom : CLRefreshControlTypeTop];
}

- (id)initWithType:(CLRefreshControlType)type {
    return [self initWithType:type style:CLRefreshControlStyleArrow];
}

- (id)initWithType:(CLRefreshControlType)type style:(CLRefreshControlStyle)style
{
    self = [super initWithLocation:type == CLRefreshControlTypeTop ? CLScrollTriggerViewLocationTop : CLScrollTriggerViewLocationBottom minTriggerDistance:CLRefreshControlTriggerDistance];

    if (self) {
        _style = style;
    }

    return self;
}


#pragma mark - layout

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = ColorWithNumberRGB(0xbdbdbd);
        _titleLabel.font      = [UIFont boldSystemFontOfSize:14.f];
        [self addSubview:_titleLabel];

        //居中
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        if (self.style == CLRefreshControlStyleArrow) {
            setCenterConstraint(_titleLabel, self);
        }else {
            setRelatedCommonAttrConstraint(_titleLabel, NSLayoutAttributeCenterY, self, 1.f, 0.f);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-18.f]];
        }
    }

    return _titleLabel;

}

- (CLActivityIndicatorView *)activityIndicatorView
{
    if (self.style == CLRefreshControlStyleProgress) {

        if (_activityIndicatorView == nil) {
            _activityIndicatorView = [[CLActivityIndicatorView alloc] initWithStyle:CLActivityIndicatorViewStyleDeterminate];
            //            _activityIndicatorView.bounds           = CGRectMake(0.f, 0.f, 22.f, 22.f);
            _activityIndicatorView.hidesWhenStopped = NO;
            _activityIndicatorView.clockwise        = self.type == CLRefreshControlTypeTop;
            _activityIndicatorView.twoStepAnimation = NO;
            [self addSubview:_activityIndicatorView];

            //竖直居中且到label距离一定
            _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
            setRelatedCommonAttrConstraint(_activityIndicatorView, NSLayoutAttributeCenterY, self, 1.f, 0.f);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.f constant:-20.f]];
            setSizeConstraint(_activityIndicatorView, NSLayoutAttributeWidth, 22.f);
            setSizeConstraint(_activityIndicatorView, NSLayoutAttributeHeight, 22.f);
        }

        return _activityIndicatorView;
    }

    return nil;
}

- (UIActivityIndicatorView *)sysActivityIndicatorView
{
    if (self.style == CLRefreshControlStyleArrow) {

        if (_sysActivityIndicatorView == nil) {
            _sysActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _sysActivityIndicatorView.color = self.titleLabel.textColor;
            _sysActivityIndicatorView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
            [self addSubview:_sysActivityIndicatorView];

            //和箭头中心对齐
            _sysActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_sysActivityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.arrowImage attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_sysActivityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.arrowImage attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        }

        return _sysActivityIndicatorView;
    }

    return nil;
}

- (UIImageView *)arrowImage
{
    if (self.style == CLRefreshControlStyleArrow) {

        if (_arrowImage == nil) {
            _arrowImage = [[UIImageView alloc] initWithImage:ImageWithName(@"ic_arrow_down.png")];
            [self addSubview:_arrowImage];

            //竖直居中且到label距离一定
            _arrowImage.translatesAutoresizingMaskIntoConstraints = NO;
            setRelatedCommonAttrConstraint(_arrowImage, NSLayoutAttributeCenterY, self, 1.f, 0.f);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_arrowImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.f constant:-8.f]];

        }

        return _arrowImage;
    }

    return nil;
}

#pragma mark - UI

- (CLRefreshControlType)type {
    return self.location == CLScrollTriggerViewLocationTop ? CLRefreshControlTypeTop : CLRefreshControlTypeBottom;
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}
- (void)setTextColor:(UIColor *)textColor
{
    self.titleLabel.textColor = textColor;
    self.sysActivityIndicatorView.color = textColor;
}

- (UIFont *)textFont {
    return self.titleLabel.font;
}
- (void)setTextFont:(UIFont *)textFont {
    self.titleLabel.font = textFont;
}

- (NSMutableDictionary *)textDictionary
{
    if (!_textDictionary) {

        if (self.style == CLRefreshControlStyleArrow) {

            if (self.type == CLRefreshControlTypeTop) {
                _textDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"下拉刷新"   ,@(CLScrollTriggerViewStatusNormal),
                                   @"释放刷新"   ,@(CLScrollTriggerViewStatusReadyToTrigger),
                                   @"更新中...",@(CLScrollTriggerViewStatusTriggering),nil];
            }else{
                _textDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"上拉加载"   ,@(CLScrollTriggerViewStatusNormal),
                                   @"释放加载"   ,@(CLScrollTriggerViewStatusReadyToTrigger),
                                   @"正在努力加载中...",@(CLScrollTriggerViewStatusTriggering),nil];

            }

        }else {

            if (self.type == CLRefreshControlTypeTop) {
                _textDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"下拉刷新"   ,@(CLScrollTriggerViewStatusNormal),
                                   @"释放刷新"   ,@(CLScrollTriggerViewStatusReadyToTrigger),
                                   @"刷新中...",@(CLScrollTriggerViewStatusTriggering),nil];
            }else{
                _textDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"上拉加载"   ,@(CLScrollTriggerViewStatusNormal),
                                   @"释放加载"   ,@(CLScrollTriggerViewStatusReadyToTrigger),
                                   @"加载中...",@(CLScrollTriggerViewStatusTriggering),nil];

            }
        }
    }

    return _textDictionary;
}

- (void)setText:(NSString *)text forStatus:(CLScrollTriggerViewStatus)status
{
    if (text != nil) {
        [self.textDictionary setObject:text forKey:@(status)];
    }else{
        [self.textDictionary removeObjectForKey:@(status)];
    }
}

- (NSString *)textForStatus:(CLScrollTriggerViewStatus)status
{
    NSString * text = [self.textDictionary objectForKey:@(status)];
    if (text == nil && status != CLScrollTriggerViewStatusNormal) {
        text = [self.textDictionary objectForKey:@(CLScrollTriggerViewStatusNormal)];
    }

    return text;
}

- (void)_updateText {
    self.titleLabel.text = [self textForStatus:self.status];
}

#pragma mark -

- (void)updateViewForReset
{
    [super updateViewForReset];

    if (self.style == CLRefreshControlStyleArrow) {

        [self.sysActivityIndicatorView stopAnimating];
        self.arrowImage.hidden = NO;
        self.arrowImage.transform = self.type == CLRefreshControlTypeTop ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);

    }else {
        self.activityIndicatorView.style = CLActivityIndicatorViewStyleDeterminate;
        self.activityIndicatorView.progress = 0.f;
    }

    //更新文本
    [self _updateText];
}

- (void)statusDidChangeFromStatus:(CLScrollTriggerViewStatus)fromStatus
{
    [super statusDidChangeFromStatus:fromStatus];

    switch (self.status) {
        case CLScrollTriggerViewStatusNormal:

            //
            if (self.type == CLRefreshControlTypeBottom &&
                fromStatus == CLScrollTriggerViewStatusTriggering) {
                [super updateViewForReset];
            }

            if (self.style == CLRefreshControlStyleArrow) {

                [self.sysActivityIndicatorView stopAnimating];
                self.arrowImage.hidden = NO;
                self.arrowImage.transform = self.type == CLRefreshControlTypeTop ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);

            }else {

                self.activityIndicatorView.style = CLActivityIndicatorViewStyleDeterminate;
                self.activityIndicatorView.progress = 0.f;
            }

            break;

        case CLScrollTriggerViewStatusBeginReadyTrigger:

            if (fromStatus == CLScrollTriggerViewStatusReadyToTrigger) {

                if (self.style == CLRefreshControlStyleArrow) {

                    [UIView animateWithDuration:0.2 animations:^{

                        self.arrowImage.transform = self.type == CLRefreshControlTypeTop ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
                    }];

                }else {

                    self.activityIndicatorView.style = CLActivityIndicatorViewStyleDeterminate;
                    self.activityIndicatorView.progress = self.activityIndicatorView.indeterminateProgress;
                }

            }

            break;

        case CLScrollTriggerViewStatusReadyToTrigger:

            if (self.style == CLRefreshControlStyleArrow) {

                [UIView animateWithDuration:0.2 animations:^{

                    self.arrowImage.transform = self.type == CLRefreshControlTypeBottom ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
                }];

            }else {

                self.activityIndicatorView.style = CLActivityIndicatorViewStyleIndeterminate;
            }

            break;

        case CLScrollTriggerViewStatusTriggering:

            if (self.style == CLRefreshControlStyleArrow) {

                self.arrowImage.hidden = YES;
                [self.sysActivityIndicatorView startAnimating];

            }else {

                self.activityIndicatorView.style = CLActivityIndicatorViewStyleIndeterminate;
                [self.activityIndicatorView startAnimating];
            }

            break;

        default:
            break;
    }

    //更新文本
    [self _updateText];
}

- (void)updateViewForTriggerProgress:(float)progress
{
    [super updateViewForTriggerProgress:progress];

    if (self.style == CLRefreshControlStyleProgress) {
        self.activityIndicatorView.progress = progress * self.activityIndicatorView.indeterminateProgress;
    }
}

#pragma mark -

- (BOOL)isRefreshing {
    return self.status == CLScrollTriggerViewStatusTriggering;
}

- (void)beginRefreshing {
    [self beginRefreshing_e:YES];
}

- (void)beginRefreshing_e:(BOOL)scrollToShow {
    [self beginTrigger_e:scrollToShow];
}

- (void)endRefreshing {
    [self endTrigger];
}

@end
