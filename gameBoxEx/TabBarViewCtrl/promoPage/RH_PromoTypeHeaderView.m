//
//  RH_PromoTypeHeaderView.m
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_PromoTypeHeaderView.h"
#import "RH_PromoCategoryCell.h"
#import "coreLib.h"

@interface RH_PromoTypeHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) UICollectionView *collectionTypeView ;
@property (nonatomic,strong) NSArray *arrayTypeList ;
@end

@implementation RH_PromoTypeHeaderView
@synthesize collectionTypeView = _collectionTypeView ;
@synthesize selectedType = _selectedType ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
    [self addSubview:self.collectionTypeView] ;
    [self.collectionTypeView reloadData] ;
    _selectedType = 0 ;
     [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedType inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone] ;
}

-(void)updateView:(NSArray*)typeList
{
    self.arrayTypeList = ConvertToClassPointer(NSArray, typeList) ;
    [self.collectionTypeView reloadData] ;
    NSLog(@"...........height:%f",self.collectionTypeView.contentSize.height) ;
}

#pragma mark -
-(UICollectionView *)collectionTypeView
{
    if (!_collectionTypeView){
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.f, 10.0f, 10.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionTypeView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout] ;
        _collectionTypeView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ;
        _collectionTypeView.delegate = self ;
        _collectionTypeView.dataSource = self ;
        _collectionTypeView.backgroundColor = [UIColor clearColor] ;
        [_collectionTypeView registerCellWithClass:[RH_PromoCategoryCell class]] ;
    }
    
    return _collectionTypeView ;
}

#pragma mark-
-(NSInteger)allTypes
{
    return self.arrayTypeList.count ;
}

-(NSInteger)selectedType
{
    return _selectedType ;
}

-(void)setSelectedType:(NSInteger)selectedType
{
    _selectedType = selectedType ;
    [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedType inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone] ;
}

-(CGSize)containSize
{
    return self.collectionTypeView.contentSize ;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.arrayTypeList.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_PromoCategoryCell *typeCell = [self.collectionTypeView dequeueReusableCellWithReuseIdentifier:[RH_PromoCategoryCell defaultReuseIdentifier] forIndexPath:indexPath];
    [typeCell updateViewWithInfo:nil context:self.arrayTypeList[indexPath.item]] ;
    return typeCell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_PromoCategoryCell sizeForViewWithInfo:nil containerViewSize:collectionView.bounds.size context:self.arrayTypeList[indexPath.item]] ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     _selectedType = indexPath.item ;
//    if (self.pageLoadManager.currentDataCount){
//        if (HasLogin)
//        {
//            RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, [self.pageLoadManager dataAtIndexPath:indexPath]) ;
//            if (lotteryInfoModel.mGameLink.length){
//                self.appDelegate.customUrl = lotteryInfoModel.showGameLink ;
//                [self showViewController:[RH_GamesViewController viewController] sender:self] ;
//                return ;
//            }else if (lotteryInfoModel.mGameMsg.length){
//                showAlertView(@"提示信息",lotteryInfoModel.mGameMsg) ;
//                return ;
//            }else if ([self.serviceRequest isRequesting]){
//                showAlertView(@"提示信息",@"数据处理中,请稍等...") ;
//                return ;
//            }else{
//                showAlertView(@"提示信息",@"游戏维护中") ;
//                return ;
//            }
//        }else{
//            showAlertView(@"提示信息", @"您尚未登入") ;
//        }
//    }
}
@end
