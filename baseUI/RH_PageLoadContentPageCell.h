//
//  RH_PageLoadContentPageCell.h
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPageLoadContentPageCell.h"
#import "RH_PageCellProtocol.h"
#import "coreLib.h"

@interface RH_PageLoadContentPageCell : CLPageLoadContentPageCell<RH_PageCellProtocol>
//分页加载的指示器
- (RH_LoadingIndicateView *)pageLoadingIndicateView;

//显示无内容指示视图
- (BOOL)showNotingIndicaterView;

//无内容指示title
- (NSString *)nothingIndicateTitle;

//用于统计的分页记载数据，返回nil将忽略统计，默认为nil
- (Class)pageLoadDataClassForStatistics;

@end
