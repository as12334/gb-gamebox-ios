//
//  CLHeaderTitleView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLHeaderTitleView.h"
#import "coreLib.h"

@interface CLHeaderTitleView()
@property(nonatomic,strong,readonly) NSLayoutConstraint *leftEdgeConstraint ;
@end

@implementation CLHeaderTitleView
@synthesize leftEdgeConstraint = _leftEdgeConstraint ;
@synthesize labTitle = _labTitle ;

-(UILabel*)labTitle
{
    if (!_labTitle){
        _labTitle = [[UILabel alloc] init] ;
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO ;
        _labTitle.numberOfLines = 0 ;
        _labTitle.textAlignment = NSTextAlignmentLeft ;

        [self addSubview:_labTitle] ;
        setRelatedCommonAttrConstraint(_labTitle, NSLayoutAttributeCenterY, self,1.f,0.f);

        [self addConstraint:self.leftEdgeConstraint] ;
    }

    return _labTitle ;
}

-(NSLayoutConstraint*)leftEdgeConstraint
{
    if (!_leftEdgeConstraint){
        _leftEdgeConstraint = [NSLayoutConstraint constraintWithItem:_labTitle
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1
                                                            constant:self.leftEdgeInset] ;
    }

    return _leftEdgeConstraint ;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    if (titleFont)
        self.labTitle.font = titleFont ;
}

-(UIFont*)titleFont
{
    return self.labTitle.font ;
}

-(void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor)
        self.labTitle.textColor = titleColor ;
}

-(UIColor*)titleColor
{
    return self.labTitle.textColor ;
}


-(void)setLeftEdgeInset:(CGFloat)leftEdgeInset
{
    if (leftEdgeInset !=_leftEdgeInset){
        _leftEdgeInset = leftEdgeInset ;

        if (_labTitle && _leftEdgeConstraint){
            [self removeConstraint:_leftEdgeConstraint] ;
            _leftEdgeConstraint = nil ;

            [self addConstraint:self.leftEdgeConstraint] ;
            [self setNeedsLayout] ;
        }
    }
}

@end
