//
//  CLStaticCollectionViewTitleCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/15.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLStaticCollectionViewTitleCell.h"
#import "MacroDef.h"
#import "coreLib.h"

@interface CLStaticCollectionViewTitleCell ()
@end

@implementation CLStaticCollectionViewTitleCell
@synthesize labTitle = _labTitle ;

-(UILabel*)labTitle
{
    if (!_labTitle){
        _labTitle = [[CLLabel alloc] init] ;
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO ;
        _labTitle.numberOfLines = 0 ;
        _labTitle.textAlignment = NSTextAlignmentCenter ;
        _labTitle.adjustsFontSizeToFitWidth = YES ;
        _labTitle.minimumScaleFactor = 0.5 ;
        [self addSubview:_labTitle] ;
        setCenterConstraint(_labTitle, self) ;
//        setAllEdgeConstraint(_labTitle, self, 1.0) ;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_labTitle
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0 constant:1.0f]] ;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:_labTitle
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0 constant:1.0f]] ;
        
    }

    return _labTitle ;
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

#pragma mark-
@end
