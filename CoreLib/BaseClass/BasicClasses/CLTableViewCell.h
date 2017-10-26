//
//  CLTableViewCell.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSelectionProtocol.h"
//----------------------------------------------------------

typedef NS_ENUM(int,CLTableViewCellSeparatorLineStyle){
    CLTableViewCellSeparatorLineStyleNone,
    CLTableViewCellSeparatorLineStyleLine,
    CLTableViewCellSeparatorLineStyleGradient
};


//----------------------------------------------------------

@interface CLTableViewCell : UITableViewCell<CLSelectionProtocol>

//默认为MyTableViewCellSeparatorLineStyleNone
@property(nonatomic) CLTableViewCellSeparatorLineStyle separatorLineStyle;
//分割线颜色,默认为灰色
@property(nonatomic,strong) UIColor * separatorLineColor;
//分割线宽度
@property(nonatomic) CGFloat separatorLineWidth;
//分割线inset
@property(nonatomic) UIEdgeInsets mySeparatorLineInset;


//设置需要更新cell
- (void)setNeedUpdateCell;
//更新cell，如果需要的话
- (void)updateCellIfNeeded;
//更新cell,子类重载进行必要的操作
- (void)updateCell;

@end
