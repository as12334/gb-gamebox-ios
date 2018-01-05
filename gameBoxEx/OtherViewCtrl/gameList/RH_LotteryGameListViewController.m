//
//  RH_LotteryGameListViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LotteryGameListViewController.h"
#import "RH_LotteryGameListTopView.h"
#import "RH_GameListCollectionViewCell.h"
@interface RH_LotteryGameListViewController ()
@property(nonatomic,strong,readonly)RH_LotteryGameListTopView *searchView;
@end

@implementation RH_LotteryGameListViewController
@synthesize searchView = _searchView;
-(BOOL)hasTopView
{
    return YES;
}
-(CGFloat)topViewHeight
{
    return 35;
}
-(BOOL)isSubViewController
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    [self.topView addSubview:self.searchView];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width,0);
    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake(110, 150);
    self.contentCollectionView = [self createCollectionViewWithLayout:layout updateControl:NO loadControl:NO];
    self.contentCollectionView.delegate=self;
    self.contentCollectionView.dataSource=self;
    [self.contentCollectionView registerCellWithClass:[RH_GameListCollectionViewCell class]] ;
    [self.contentView addSubview:self.contentCollectionView] ;
    [self.contentCollectionView reloadData] ;
}
#pragma mark searchView
-(RH_LotteryGameListTopView *)searchView
{
    if (!_searchView) {
        _searchView = [RH_LotteryGameListTopView createInstance];
        _searchView.frame = CGRectMake(0, 0, self.topView.frameWidth, 35);
    }
    return _searchView;
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
    return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//      RH_GameListCollectionViewCell *noticeCell = [self.contentCollectionView dequeueReusableCellWithIdentifier:[RH_GameListCollectionViewCell defaultReuseIdentifier]];
    RH_GameListCollectionViewCell *gameCell = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:[RH_GameListCollectionViewCell defaultReuseIdentifier] forIndexPath:indexPath];
    return gameCell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frameWidth-50)/4, (self.view.frameWidth-50)/4*7/5);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

@end
