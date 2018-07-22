//
//  RH_CapitalQuickSelectView.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CapitalQuickSelectViewBlock)(NSInteger selectRow);
@interface RH_CapitalQuickSelectView : UIView
@property(nonatomic,copy)CapitalQuickSelectViewBlock quickSelectBlock;
@property(nonatomic,strong)UITableView *mainTabelView;
@end
