//
//  RH_GameListHeaderView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListHeaderView.h"
#import "coreLib.h"
#import "RH_GameCategoryCell.h"

@interface RH_GameListHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) UICollectionView *collectionTypeView ;
@property (nonatomic,strong) NSArray *arrayTypeList ;
@end

@implementation RH_GameListHeaderView

@synthesize collectionTypeView = _collectionTypeView ;
@synthesize selectedIndex = _selectedIndex ;


-(instancetype)init
{
    self = [super init] ;
    if (self){
        self.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self addSubview:self.collectionTypeView] ;
        [self.collectionTypeView reloadData] ;
        _selectedIndex = 0 ;
    }
    return self ;
}

-(void)updateView:(NSArray*)typeList
{
    self.arrayTypeList = ConvertToClassPointer(NSArray, typeList) ;
    [self.collectionTypeView reloadData] ;
    [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone] ;
}

-(NSDictionary *)typeModelWithIndex:(NSInteger)index
{
    if (index>=0 && index <self.arrayTypeList.count){
        return self.arrayTypeList[index] ;
    }
    
    return nil ;
}

#pragma mark -
-(UICollectionView *)collectionTypeView
{
    if (!_collectionTypeView){
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.f, 10.0f, 10.0f) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        _collectionTypeView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout] ;
        _collectionTypeView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ;
        _collectionTypeView.delegate = self ;
        _collectionTypeView.dataSource = self ;
        _collectionTypeView.backgroundColor = [UIColor clearColor] ;
        _collectionTypeView.showsHorizontalScrollIndicator = NO;
        [_collectionTypeView registerCellWithClass:[RH_GameCategoryCell class]] ;
    }
    
    return _collectionTypeView ;
}

#pragma mark-
-(NSInteger)allTypes
{
    return self.arrayTypeList.count ;
}

-(NSInteger)selectedIndex
{
    return _selectedIndex ;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex!=selectedIndex){
        _selectedIndex = selectedIndex ;
        [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone] ;
    }
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
    RH_GameCategoryCell *typeCell = [self.collectionTypeView dequeueReusableCellWithReuseIdentifier:[RH_GameCategoryCell defaultReuseIdentifier] forIndexPath:indexPath];
    [typeCell updateViewWithInfo:ConvertToClassPointer(NSDictionary, self.arrayTypeList[indexPath.item]) context:nil] ;
    return typeCell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_GameCategoryCell sizeForViewWithInfo:nil containerViewSize:collectionView.bounds.size context:self.arrayTypeList[indexPath.item]] ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:indexPath.item] ;
    ifRespondsSelector(self.delegate, @selector(gameListHeaderViewDidChangedSelectedIndex:SelectedIndex:)){
        [self.delegate gameListHeaderViewDidChangedSelectedIndex:self SelectedIndex:_selectedIndex] ;
    }
    
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
