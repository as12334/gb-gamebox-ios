//
//  KIPageViewCell.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "CLSelectionView.h"

@interface KIPageViewCell : CLSelectionView

- (instancetype)initWithIdentifier:(NSString *)identifier;

@property (nonatomic, readonly, copy) NSString  * reuseIdentifier;

@end
