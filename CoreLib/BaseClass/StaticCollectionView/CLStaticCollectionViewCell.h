//
//  CLStaticCollectionViewCell.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/10.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLSelectionView.h"

@interface CLStaticCollectionViewCell : CLSelectionView
@property(nonatomic,readonly,strong) NSString *reuseIdentifier ;

+ (NSString *)defaultReuseIdentifier;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setupReuseIdentifier:(NSString *)reuseIdentifier ;

//加入复用池前调用，默认没有做任何事
- (void)didAddToReusePool;
//复用前调用，默认没有做任何事
- (void)prepareForReuse;


- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context;

//设置需要更新cell
- (void)setNeedUpdateCell;
//更新cell，如果需要的话
- (void)updateCellIfNeeded;
//更新cell,子类重载进行必要的操作
- (void)updateCell;

- (BOOL)touchPointInside:(CGPoint)point;

@end
