//
//  RH_DepositeSystemPlatformCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeSystemPlatformCell.h"
#import "coreLib.h"
#import "RH_DepositeSystemPlatformSubCell.h"
#define HomeCategoryItemsCellWidth                     170.f
#define HomeCategoryItemsCellHeight                     30.0f
@interface RH_DepositeSystemPlatformCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RH_DepositeSystemPlatformCell
@synthesize collectionView = _collectionView ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return  80.f;
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
    flowLayout.itemSize =CGSizeMake(170, 40);
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.backgroundColor = [UIColor whiteColor] ;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
    [_collectionView registerCellWithClass:[RH_DepositeSystemPlatformSubCell class]];
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeSystemPlatformSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_DepositeSystemPlatformSubCell defaultReuseIdentifier] forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(depositeSystemPlatformCellDidtouch:indexCellItem:)){
        [self.delegate depositeSystemPlatformCellDidtouch:self indexCellItem:indexPath.section*2+indexPath.item] ;
    }
}


@end
