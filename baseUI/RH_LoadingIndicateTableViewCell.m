//
//  RH_LoadingIndicateTableViewCell.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/28.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_LoadingIndicateTableViewCell.h"

@implementation RH_LoadingIndicateTableViewCell

@synthesize loadingIndicateView = _loadingIndicateView;

+ (CGFloat)heightForCellWithDesignHeight:(CGFloat)designHeight {
    return MAX(designHeight, 300.f);
}

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info
                       tableView:(UITableView *)tableView
                         context:(id)context
{
    return 300.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithLoadingIndicateViewClass:nil];
}

- (id)initWithLoadingIndicateViewClass:(Class)loadingIndicateViewClass
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    if (self) {

        //加载指示视图的类
        loadingIndicateViewClass = [loadingIndicateViewClass isSubclassOfClass:[RH_LoadingIndicateView class]] ? loadingIndicateViewClass : [RH_LoadingIndicateView class];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _loadingIndicateView = [[loadingIndicateViewClass alloc] initWithFrame:self.contentView.bounds];
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
