//
//  CLContentView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLContentView : UIView
//通知需要更新视图
- (void)setNeedUpdateView;

//更新视图如果需要的话
- (BOOL)updateViewIfNeeded;

//子类重载该方法进行视图更新
- (void)updateView;

@end
