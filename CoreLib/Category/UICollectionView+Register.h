//
//  UICollectionView+Register.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

@interface UICollectionReusableView (reuseIdentifier)

+ (NSString *)defaultReuseIdentifier;

@end

//----------------------------------------------------------


@interface UICollectionView (Register)
- (void)registerCellWithClass:(Class)cellClass;
- (void)registerCellWithClass:(Class)cellClass andReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerCellWithClass:(Class)cellClass
                 nibNameOrNil:(NSString *)nibNameOrNil
                  bundleOrNil:(NSBundle *)bundleOrNil
           andReuseIdentifier:(NSString *)reuseIdentifier;

- (void)registerSupplementaryViewWithClass:(Class)supplementaryViewClass elementKind:(NSString *)elementKind;
- (void)registerSupplementaryViewWithClass:(Class)supplementaryViewClass
                               elementKind:(NSString *)elementKind
                        andReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerSupplementaryViewWithClass:(Class)supplementaryViewClass
                               elementKind:(NSString *)elementKind
                              nibNameOrNil:(NSString *)nibNameOrNil
                               bundleOrNil:(NSBundle *)bundleOrNil
                        andReuseIdentifier:(NSString *)reuseIdentifier;

@end
