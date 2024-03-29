//
//  RH_BettingTableHeaderView.m
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingTableHeaderView.h"
#import "RH_BettingStaticHeaderCell.h"
#import "coreLib.h"


@interface _BettingHeaderCellModel:NSObject
@property(nonatomic,strong,readonly) NSString *mName        ;
@property(nonatomic,strong) NSString *mDescript        ;
-(instancetype)initWithName:(NSString*)name Descript:(NSString*)desc ;

@end

@implementation _BettingHeaderCellModel
-(instancetype)initWithName:(NSString*)name Descript:(NSString*)desc
{
    self = [super init] ;
    if (self){
        _mName = name ;
        _mDescript = desc ;
    }
    
    return self ;
}

@end

/**************************************************************************************************/
/**************************************************************************************************/

@interface RH_BettingTableHeaderView()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource>
@property (nonatomic,strong,readonly) CLStaticCollectionView *headerStaticView ;
@end

@implementation RH_BettingTableHeaderView
{
    NSArray *_typeHeaderList ;
}

@synthesize headerStaticView = _headerStaticView ;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self){
        _typeHeaderList = @[[[_BettingHeaderCellModel alloc] initWithName:@"游戏名称" Descript:nil],
                            [[_BettingHeaderCellModel alloc] initWithName:@"投注时间" Descript:nil],
                            [[_BettingHeaderCellModel alloc] initWithName:@"投注额" Descript:nil],
                            [[_BettingHeaderCellModel alloc] initWithName:@"派彩" Descript:nil],
                            [[_BettingHeaderCellModel alloc] initWithName:@"状态" Descript:nil],
                            ] ;
        
        self.backgroundColor = colorWithRGB(225, 226, 227)  ;
        self.borderMask = CLBorderMarkTop | CLBorderMarkBottom ;
        self.borderWidth = PixelToPoint(1.0) ;
        self.borderColor = [UIColor whiteColor] ;
        
     
        
        [self addSubview:self.headerStaticView] ;
        [self.headerStaticView reloadData] ;
    }
    
    return self ;
}

-(void)updateUIInfoWithTotalNumber:(NSInteger)totalNumber SigleAmount:(CGFloat)single ProfitAmount:(CGFloat)profitAmount
{
    
//    _BettingHeaderCellModel *headerCell1 = ConvertToClassPointer(_BettingHeaderCellModel, _typeHeaderList[0]) ;
//    _BettingHeaderCellModel *headerCell2 = ConvertToClassPointer(_BettingHeaderCellModel, _typeHeaderList[2]) ;
//    _BettingHeaderCellModel *headerCell3 = ConvertToClassPointer(_BettingHeaderCellModel, _typeHeaderList[3]) ;
    
//    headerCell1.mDescript = [NSString stringWithFormat:@"总共%ld笔",totalNumber] ;
//    headerCell2.mDescript = [NSString stringWithFormat:@"￥%0.02f",single] ;
//    headerCell3.mDescript = [NSString stringWithFormat:@"￥%0.02f",profitAmount] ;
    [self.headerStaticView reloadData] ;
}



#pragma mark-
-(CLStaticCollectionView *)headerStaticView
{
    if (!_headerStaticView){
        _headerStaticView = [[CLStaticCollectionView alloc] initWithFrame:self.bounds] ;
        _headerStaticView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        _headerStaticView.dataSource = self ;
        _headerStaticView.delegate = self ;
        _headerStaticView.allowSelection = YES ;
        _headerStaticView.allowCellSeparationLine = YES ;
        _headerStaticView.allowSectionSeparationLine = NO ;
        _headerStaticView.averageCellWidth = NO ;
        _headerStaticView.separationLineColor = [UIColor whiteColor];
        _headerStaticView.separationLineWidth = 2.0f ;
        _headerStaticView.backgroundColor = [UIColor clearColor] ;
    }
    
    return _headerStaticView ;
}

#pragma mark-
- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return _typeHeaderList.count ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_BettingStaticHeaderCell * cell = [collectionView dequeueReusableCellWithIdentifier:defaultReuseDef];
    if (cell == nil) {
        cell = [RH_BettingStaticHeaderCell createInstance];
    }
    
    _BettingHeaderCellModel *cellModel = [_typeHeaderList objectAtIndex:indexPath.item] ;
    [cell updateCellWithTitle:cellModel.mName Description:cellModel.mDescript] ;
    
    return cell;
}


- (NSString*)staticCollectionView:(CLStaticCollectionView *)collectionView cellWidthWeightAtIndexPath:(NSUInteger)section
{
    return @"1:1.3:0.8:0.8:0.8" ;
}
@end
