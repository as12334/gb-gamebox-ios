//
//  CLStaticCollectionView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBorderView.h"
#import "CLStaticCollectionViewCell.h"

@class CLStaticCollectionView ;

@protocol CLStaticCollectionViewDataSource <NSObject>
@required
- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView
            numberOfItemsInSection:(NSUInteger)section;

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView
                              cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSUInteger)numberOfSectionInStaticCollectionView:(CLStaticCollectionView *)collectionView;
/*
 *返回每个section all Cell的宽度权重值，@“0.1:0.2”
 */
- (NSString*)staticCollectionView:(CLStaticCollectionView *)collectionView
         cellWidthWeightAtIndexPath:(NSUInteger)section;


@end


@protocol CLStaticCollectionViewDelegate <NSObject>
@optional
- (BOOL)staticCollectionView:(CLStaticCollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)staticCollectionView:(CLStaticCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)staticCollectionView:(CLStaticCollectionView *)collectionView didUnHighlightItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)staticCollectionView:(CLStaticCollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)staticCollectionView:(CLStaticCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)staticCollectionView:(CLStaticCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

//======================================
/**
 * 类似九宫格显示效果图,cell 大小均等
 */
//======================================

@interface CLStaticCollectionView : CLBorderView
@property(nonatomic) CGFloat separationLineWidth              ;
@property(nonatomic) UIEdgeInsets separationLineInset         ;
@property(nonatomic,strong) UIColor* separationLineColor      ;

@property(nonatomic,assign) BOOL allowSelection               ;
@property(nonatomic,assign) BOOL allowCellSeparationLine      ;
@property(nonatomic,assign) BOOL averageCellWidth             ;// cell 宽度是否平均分，

@property(nonatomic,weak) id<CLStaticCollectionViewDataSource> dataSource ;
@property(nonatomic,weak) id<CLStaticCollectionViewDelegate> delegate   ;


-(void)reloadData ;
-(void)reloadDataAtIndexPath:(NSIndexPath*)indexPath ;


-(CLStaticCollectionViewCell*)cellAtIndexPath:(NSIndexPath*)indexPath ;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier ;

@end
