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
#import "RH_DepositeTransferChannelModel.h"
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-44)/2.0)
#define HomeCategoryItemsCellHeight                     40.0f
@interface RH_DepositeSystemPlatformCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *listModelArray;
@property (nonatomic,strong)RH_DepositeTransferChannelModel *channelModel;
@property (nonatomic,assign)NSInteger cellStatusIndex;
@property (nonatomic,strong)RH_DepositeTansferCounterModel *counterModel;
@property (nonatomic,strong)NSArray *counterArray;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@end

@implementation RH_DepositeSystemPlatformCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    NSInteger num = array.count%2?((array.count/2)+1):(array.count/2);
    return  50.f+55*num;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor] ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    _cellStatusIndex = 0;
//    [self.collectionView reloadData] ;
    [self setupUI];
}
-(void)updateConllectionView
{
    [self awakeFromNib];
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.channelModel = ConvertToClassPointer(RH_DepositeTransferChannelModel, context);
    self.listModelArray = ConvertToClassPointer(NSArray, self.channelModel.mArrayListModel);
    self.counterArray = ConvertToClassPointer(NSArray, self.channelModel.mAounterModel);
    RH_DepositeTransferListModel *listModel = self.listModelArray[0];
    if ([listModel.mDepositWay isEqualToString:@"online_deposit"]) {
        self.listModelArray=@[];
    }
    else {
       [self.collectionView reloadData] ;
    }
}
#pragma mark--
#pragma mark--lazy
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 19.f;
        _flowLayout.minimumInteritemSpacing = 5.0f ;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 5, 0.f);
        _flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellHeight) ;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //    flowLayout.itemSize =CGSizeMake(170, 40);
    }
    return _flowLayout;
}
#pragma mark-
-(void)setupUI
{
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor whiteColor] ;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 19, 10) ;
    [self.collectionView registerCellWithClass:[RH_DepositeSystemPlatformSubCell class]];
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeSystemPlatformSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_DepositeSystemPlatformSubCell defaultReuseIdentifier] forIndexPath:indexPath];
    [cell updateViewWithInfo:nil context:self.listModelArray[indexPath.item]];
    if (indexPath.item == _cellStatusIndex) {
        cell.layer.borderWidth = 1.f;
        cell.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
    }
    else
    {
        cell.layer.borderWidth = 0.f;
        cell.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, self.listModelArray[indexPath.item]);
    ifRespondsSelector(self.delegate, @selector(depositeSystemPlatformCellDidtouch:payTypeString:accountModel:acounterModel:)){
        [self.delegate depositeSystemPlatformCellDidtouch:self payTypeString :listModel.mType accountModel:listModel acounterModel:self.counterArray];
    }
    _cellStatusIndex = indexPath.item ;
    [self.collectionView reloadData];
}

@end
