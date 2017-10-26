//
//  RH_LoadingIndicateTableViewCell.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/28.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_LoadingIndicateView.h"

@interface RH_LoadingIndicateTableViewCell : UITableViewCell
+ (CGFloat)heightForCellWithDesignHeight:(CGFloat)designHeight;
- (id)initWithLoadingIndicateViewClass:(Class)loadingIndicateViewClass;

@property(nonatomic,strong,readonly) RH_LoadingIndicateView * loadingIndicateView;
@property(nonatomic) UIEdgeInsets contentInset;

@end
