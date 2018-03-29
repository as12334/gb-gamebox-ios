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
#import "RH_DepositeTransferModel.h"
#import "RH_DepositePayAccountModel.h"
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-44)/2.0)
#define HomeCategoryItemsCellHeight                     40.0f
@interface RH_DepositeSystemPlatformCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *accountModelArray;
@property (nonatomic,strong)RH_DepositePayModel *payModel;
@property (nonatomic,assign)NSInteger cellStatusIndex;
@end

@implementation RH_DepositeSystemPlatformCell
@synthesize collectionView = _collectionView ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_DepositePayModel *payModel = ConvertToClassPointer(RH_DepositePayModel, context);
    NSArray *array = ConvertToClassPointer(NSArray, payModel.mPayAccounts);
    NSInteger num = array.count%2?((array.count/2)+1):(array.count/2);
    return  50.f+50*num;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor] ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    _cellStatusIndex = 100;
    [self.collectionView reloadData] ;
    [self setupUI];
}
-(void)updateConllectionView
{
    [self awakeFromNib];
}
#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositePayModel *payModel = ConvertToClassPointer(RH_DepositePayModel, context);
    _payModel = payModel;
    _accountModelArray = ConvertToClassPointer(NSArray, payModel.mPayAccounts);
    [self.collectionView reloadData] ;    
}

#pragma mark-
-(void)setupUI
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 19.f;
    flowLayout.minimumInteritemSpacing = 5.0f ;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 5, 0.f);
    flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellHeight) ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.itemSize =CGSizeMake(170, 40);
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.backgroundColor = [UIColor whiteColor] ;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 19, 10) ;
    [_collectionView registerCellWithClass:[RH_DepositeSystemPlatformSubCell class]];
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.accountModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeSystemPlatformSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_DepositeSystemPlatformSubCell defaultReuseIdentifier] forIndexPath:indexPath];
    [cell updateViewWithInfo:nil context:self.accountModelArray[indexPath.item]];
    if (indexPath.item == _cellStatusIndex) {
//        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.layer.borderWidth = 1.f;
        cell.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
    }
    else
    {
//        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        cell.layer.borderWidth = 0.f;
        cell.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, self.accountModelArray[indexPath.item]);
    ifRespondsSelector(self.delegate, @selector(depositeSystemPlatformCellDidtouch:codeString:accountModel:)){
        [self.delegate depositeSystemPlatformCellDidtouch:self codeString:self.payModel.mCode accountModel:accountModel] ;
    }
    _cellStatusIndex = indexPath.item ;
    [self.collectionView reloadData];
}

@end
