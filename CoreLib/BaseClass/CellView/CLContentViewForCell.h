//
//  CLContentViewForCell.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLSelectionView.h"
#import "NSObject+ShowViewControllerDelegate.h"
#import "CLSelectionView.h"
#import "NSDictionary+CLCategory.h"
#import "CLCellContext.h"

//----------------------------------------------------------

@class CLContentViewForCell;

//----------------------------------------------------------

@protocol CLContentViewForCellDelegate <CLShowViewControllerDelegate>

@optional

- (void)contentView:(CLContentViewForCell *)contentView willUseWithContext:(CLCellContext *)context;
- (void)contentViewWillEndUse:(CLContentViewForCell *)contentView;


@end

//----------------------------------------------------------

@interface CLContentViewForCell : CLSelectionView

//获取尺寸
+ (CGSize)sizeForContentViewWithInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize context:(CLCellContext *)context;

//更新视图.默认没有做任何事
- (void)updateViewWithInfo:(NSDictionary *)info;

//上下文和信息
@property(nonatomic,strong,readonly) CLCellContext *context;
@property(nonatomic,strong,readonly) NSDictionary * info;

//代理
@property(nonatomic,weak) id<CLContentViewForCellDelegate> delegate;

//准备去使用，即显示
- (void)prepareForUseWithContext:(CLCellContext *)context containerCell:(id)containerCell;
//结束使用
- (void)endForUse;

//是否在使用
@property(nonatomic,readonly,getter = isUsed) BOOL used;

//包含此view的容器cell,一般为MyContentViewTableViewCell或MyContentViewCollectionViewCell实例
@property(nonatomic,weak,readonly) id containerCell;

@end

//----------------------------------------------------------

//内容视图的分配器，可通过自定义分配器生成实例
@protocol CLContentViewForCellAllocatorProtocol

- (CLContentViewForCell *)getContentViewForCellWithInfo:(NSDictionary *)info context:(CLCellContext *)context;

@end

//----------------------------------------------------------

//默认分配器
@interface CLContentViewForCellDefaultAllocator : NSObject <CLContentViewForCellAllocatorProtocol>

@end

//----------------------------------------------------------

@interface NSDictionary (CLContentViewForCell)

- (NSString *)contentViewClassName;
- (Class)contentViewClass;
- (id)contentViewForCellWithContext:(CLCellContext *)context;

@end

