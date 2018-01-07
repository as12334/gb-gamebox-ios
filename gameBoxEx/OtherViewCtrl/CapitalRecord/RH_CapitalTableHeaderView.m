//
//  RH_CapitalTableHeaderView.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalTableHeaderView.h"
#import "RH_CatipalStaticHeaderCell.h"
#import "coreLib.h"

@interface _CapitalHeaderCellModel:NSObject
@property(nonatomic,strong,readonly) NSString *withdrawalMoney        ;
@property(nonatomic,strong,readonly) NSString *transferMoney        ;
-(instancetype)initWithWithdrawalMoney:(NSString*)withdrawalMoney TransferMoney:(NSString*)transferMoney;
@end

@implementation _CapitalHeaderCellModel

-(instancetype)initWithWithdrawalMoney:(NSString*)withdrawalMoney TransferMoney:(NSString*)transferMoney
{
    self = [super init] ;
    if (self){
        _withdrawalMoney = withdrawalMoney ;
        _transferMoney = transferMoney ;
    }
    
    return self ;
}

@end

@interface RH_CapitalTableHeaderView()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource>
@property (nonatomic,strong,readonly) CLStaticCollectionView *headerStaticView ;

@end

@implementation RH_CapitalTableHeaderView

{
    NSArray *_typeHeaderList ;
}

@synthesize headerStaticView = _headerStaticView ;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self){
//        _typeHeaderList = @[[[_CapitalHeaderCellModel alloc] initWithName:@"游戏名称" Descript:@"总共0笔"],
//                            [[_BettingHeaderCellModel alloc] initWithName:@"投注时间" Descript:nil],
//                            [[_BettingHeaderCellModel alloc] initWithName:@"投注额" Descript:@"¥0.00"],
//                            [[_BettingHeaderCellModel alloc] initWithName:@"派彩" Descript:@"¥0.00"],
//                            [[_BettingHeaderCellModel alloc] initWithName:@"派彩" Descript:nil],
//                            ] ;
        
//        self.backgroundColor = colorWithRGB(225, 226, 227)  ;
        self.backgroundColor = [UIColor grayColor];
        self.borderMask = CLBorderMarkTop | CLBorderMarkBottom ;
        self.borderWidth = PixelToPoint(1.0) ;
        self.borderColor = [UIColor whiteColor] ;
        
        
        [self addSubview:self.headerStaticView] ;
        [self.headerStaticView reloadData] ;
    }
    
    return self ;
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
    RH_CatipalStaticHeaderCell* cell = [collectionView dequeueReusableCellWithIdentifier:defaultReuseDef];
    if (cell == nil) {
        cell = [RH_CatipalStaticHeaderCell createInstance];
    }
    
    _CapitalHeaderCellModel *cellModel = [_typeHeaderList objectAtIndex:indexPath.item] ;
  
    [cell updateCellWithTitle:cellModel.withdrawalMoney Description:cellModel.transferMoney];
    return cell;
}


- (NSString*)staticCollectionView:(CLStaticCollectionView *)collectionView cellWidthWeightAtIndexPath:(NSUInteger)section
{
    return @"1:1.3:0.8:0.8:0.8" ;
}

@end


