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
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-30)/3.0)
#define HomeCategoryItemsCellHeight                     70.0f
@interface RH_DepositePayforWayCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@property (nonatomic,strong)NSArray *payModelArray;
@property (nonatomic,strong) RH_DepositeTransferModel *transferModel;
@property (nonatomic,assign)NSInteger selectedBtnIndex;
@end
@implementation RH_DepositePayforWayCell

@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
     RH_DepositeTransferModel* transferModel = ConvertToClassPointer(RH_DepositeTransferModel, context);
    if (transferModel.mPayModel.count%3==0) {
        return 78*(transferModel.mPayModel.count/3);
    }
    else
    {
        return 78*(transferModel.mPayModel.count/3+1);
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _selectedBtnIndex = -1;
    self.backgroundColor = [UIColor whiteColor] ;
    self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
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
        cell.layer.masksToBounds = YES;
    }
    else
    {
        cell.layer.cornerRadius = 2;
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = colorWithRGB(224,224, 224).CGColor;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(depositePayforWayDidtouchItemCell:itemIndex:deposityWay:accountId: rechardType:)){
        RH_DepositePayModel *payModel = ConvertToClassPointer(RH_DepositePayModel, self.payModelArray[indexPath.item]);
        if ([payModel.mCode isEqualToString:@"online"]) {
            [self.delegate depositePayforWayDidtouchItemCell:self itemIndex:indexPath.item deposityWay:((RH_DepositePayAccountModel*)payModel.mPayAccounts[0]).mDepositWay accountId:((RH_DepositePayAccountModel*)payModel.mPayAccounts[0]).mId rechardType:((RH_DepositePayAccountModel*)payModel.mPayAccounts[0]).mRechargeType];
        }
        else{
            [self.delegate depositePayforWayDidtouchItemCell:self itemIndex:indexPath.item deposityWay:payModel.mName accountId:1 rechardType:nil];
        }
        
    }
    _selectedBtnIndex = indexPath.item;
    [self.collectionView reloadData];
}


@end
