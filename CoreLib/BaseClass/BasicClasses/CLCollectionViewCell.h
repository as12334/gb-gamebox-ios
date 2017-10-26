//
//  CLCollectionViewCell.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSelectionProtocol.h"
#import "CLBorderProtocol.h"

@interface CLCollectionViewCell : UICollectionViewCell<CLSelectionProtocol,CLBorderProtocol>
//设置需要更新cell
- (void)setNeedUpdateCell;
//更新cell，如果需要的话
- (void)updateCellIfNeeded;
//更新cell,子类重载进行必要的操作
- (void)updateCell;

@end
