//
//  RH_DepositeChooseMoneyCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeChooseMoneyCell.h"
#import "RH_DepositeChooseMoneySubCell.h"
#import "coreLib.h"
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-30)/3.0)
#define HomeCategoryItemsCellHeight                     70.0f
@interface RH_DepositeChooseMoneyCell()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation RH_DepositeChooseMoneyCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 70;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor] ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    [self.collectionView reloadData] ;
    [self setupUI];
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    //    self.itemsList = ConvertToClassPointer(NSArray, context) ;
    //    [self.collectionView reloadData] ;
}

#pragma mark-
-(void)setupUI
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5.f;
    flowLayout.minimumInteritemSpacing = 5.0f ;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 5, 0.f);
    flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellHeight) ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize =CGSizeMake(70, 70);
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.backgroundColor = [UIColor whiteColor] ;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
    [_collectionView registerCellWithClass:[RH_DepositeChooseMoneySubCell class]];
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeChooseMoneySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_DepositeChooseMoneySubCell defaultReuseIdentifier] forIndexPath:indexPath];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ifRespondsSelector(self.delegate, @selector(homeCategoryItemsCellDidTouchItemCell:DataModel:)){
//        [self.delegate homeCategoryItemsCellDidTouchItemCell:self DataModel:self.itemsList[indexPath.section*3+indexPath.item]] ;
//    }
//}

@end
