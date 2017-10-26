//
//  UICollectionReusableView+ShowContent.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionReusableView (ShowContent)

+ (CGSize)sizeForViewWithInfo:(NSDictionary *)info
            containerViewSize:(CGSize)containerViewSize
                      context:(id)context;

- (void)updateViewWithInfo:(NSDictionary *)info context:(id)context;

@end
