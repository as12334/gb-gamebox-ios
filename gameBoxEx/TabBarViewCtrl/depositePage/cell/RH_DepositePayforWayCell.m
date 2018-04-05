//
//  RH_DepositePayforWayCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositePayforWayCell.h"
#import "RH_DepositePayforWaySubCell.h"
#import "coreLib.h"
#import "RH_DepositeTransferModel.h"
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-50)/5.0)
#define HomeCategoryItemsCellHeight                     70.0f
@interface RH_DepositePayforWayCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *payModelArray;
@property (nonatomic,strong) RH_DepositeTransferModel *transferModel;

@end
@implementation RH_DepositePayforWayCell

//@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
     NSArray * transferModelArray = ConvertToClassPointer(NSArray, context);
    if (transferModelArray.count%5==0) {
        return 80*(transferModelArray.count/5);
    }
    else
    {
        return 80*(transferModelArray.count/5+1);
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _selectedBtnIndex = -1;
    self.backgroundColor = [UIColor whiteColor] ;
    self.contentView.backgroundColor = colorWithRGB(224, 224,224) ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    [self.contentView addSubview:self.collectionView] ;
    [self.collectionView reloadData] ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.payModelArray = ConvertToClassPointer(NSArray, context);
    [self.collectionView reloadData];
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.f;
        flowLayout.minimumInteritemSpacing = 5.0f ;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 5, 0.f);
        flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellHeight) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        flowLayout.itemSize =CGSizeMake(65, 68);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.contentView.frameWidth,
                                                                             self.contentView.frameHeigh)
                                             collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor lightTextColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
        [_collectionView registerCellWithClass:[RH_DepositePayforWaySubCell class]];
    }
    return _collectionView;
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.payModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositePayforWaySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_DepositePayforWaySubCell defaultReuseIdentifier] forIndexPath:indexPath];
    [cell updateViewWithInfo:nil context:self.payModelArray[indexPath.item]];
    if (indexPath.item == _selectedBtnIndex) {
        cell.layer.cornerRadius = 2;
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
        [cell.payforTitle setTextColor:colorWithRGB(23, 102, 187)];
        cell.layer.masksToBounds = YES;
    }
    else
    {
        cell.layer.cornerRadius = 2;
        cell.layer.borderWidth = 0;
//        cell.layer.borderColor = colorWithRGB(224,224, 224).CGColor;
        [cell.payforTitle setTextColor:colorWithRGB(51,51,51)];
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(depositePayforWayDidtouchItemCell:depositeCode:depositeName:)){

        RH_DepositeTransferModel *transferModel = ConvertToClassPointer(RH_DepositeTransferModel, self.payModelArray[indexPath.item]);
        [self.delegate depositePayforWayDidtouchItemCell:self depositeCode:transferModel.mCode depositeName:transferModel.mName];
    }
    _selectedBtnIndex = indexPath.item;
    [self.collectionView reloadData];
}


@end
