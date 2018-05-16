//
//  RH_LoadingIndicateTableViewCell.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/28.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_LoadingIndicaterCollectionViewCell.h"

@implementation RH_LoadingIndicaterCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _loadingIndicateView = [[RH_LoadingIndicateView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_loadingIndicateView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.loadingIndicateView.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, self.contentInset);
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(contentInset, _contentInset)) {
        _contentInset = contentInset;
        [self setNeedsLayout];
    }
}


@end
