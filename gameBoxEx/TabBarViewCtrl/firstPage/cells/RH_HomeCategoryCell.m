//
//  RH_HomeCategoryCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategoryCell.h"
#import "RH_HomeCategorySubCell.h"
#import "coreLib.h"

#define HomeCategoryCellHeight                    80.0f
#define HomeCategoryCellWidth                     floorf((MainScreenW-20)/5.0)

@interface RH_HomeCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@end

@implementation RH_HomeCategoryCell
@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return  HomeCategoryCellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = [UIColor clearColor] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    [self.contentView addSubview:self.collectionView] ;
    [self.collectionView reloadData] ;
    
    _selectedIndex = 0 ;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft] ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10.f, 0.0f, 10.f);
        flowLayout.itemSize = CGSizeMake(HomeCategoryCellWidth, HomeCategoryCellHeight) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerCellWithClass:[RH_HomeCategorySubCell class]];
    }
    return _collectionView;
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeCategorySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeCategorySubCell defaultReuseIdentifier] forIndexPath:indexPath];

    [cell updateViewWithInfo:nil context:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.item ;
}

@end
