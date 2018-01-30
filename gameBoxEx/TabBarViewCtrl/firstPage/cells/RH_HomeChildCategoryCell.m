//
//  RH_HomeChildCategoryCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeChildCategoryCell.h"
#import "RH_HomeChildCategorySubCell.h"
#import "coreLib.h"
#import "RH_LotteryAPIInfoModel.h"

#define HomeChildCategoryCellHeight                    40.0f
#define HomeChildCategoryCellWidth                     floorf((MainScreenW-20)/3.0)

@interface RH_HomeChildCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray  *subCategoryList ;
@property (nonatomic,strong) IBOutlet UICollectionView *collectionView ;
@end

@implementation RH_HomeChildCategoryCell
@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return  HomeChildCategoryCellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    _selectedIndex = 0 ;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self configureCollection:self.collectionView] ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.subCategoryList = ConvertToClassPointer(NSArray, context) ;
    [self.collectionView reloadData] ;
    if (_selectedIndex<0 || _selectedIndex>=self.subCategoryList.count){
        _selectedIndex = 0 ;
    }
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft] ;
}

#pragma mark-
-(void)configureCollection:(UICollectionView*)collectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 0.0f, 0.f);
    flowLayout.itemSize = CGSizeMake(HomeChildCategoryCellWidth, HomeChildCategoryCellHeight) ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionView.collectionViewLayout = flowLayout ;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = NO ;
    collectionView.allowsSelection = YES ;
    [collectionView registerCellWithClass:[RH_HomeChildCategorySubCell class]];
}


#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subCategoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeChildCategorySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeChildCategorySubCell defaultReuseIdentifier] forIndexPath:indexPath];

    [cell updateViewWithInfo:nil context:self.subCategoryList[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.item ;
    ifRespondsSelector(self.delegate, @selector(homeChildCategoryCellDidChangedSelectedIndex:)){
        [self.delegate homeChildCategoryCellDidChangedSelectedIndex:self] ;
    }
}

@end
