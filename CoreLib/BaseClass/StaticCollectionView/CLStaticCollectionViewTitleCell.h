//
//  CLStaticCollectionViewTitleCell.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/15.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@interface CLStaticCollectionViewTitleCell : CLStaticCollectionViewCell
@property(nonatomic,strong,readonly) UILabel *labTitle ;
@property(nonatomic,strong) UIFont *titleFont ;
@property(nonatomic,strong) UIColor *titleColor ;

@end
