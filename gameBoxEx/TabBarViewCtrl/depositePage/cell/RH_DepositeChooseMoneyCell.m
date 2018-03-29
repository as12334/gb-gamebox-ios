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
#import "RH_DepositeTransferModel.h"
#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-60)/5.0)
#define HomeCategoryItemsCellHeight                     (MainScreenW-60)/5.0
@interface RH_DepositeChooseMoneyCell()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) RH_DepositePaydataModel *dataModel;
@property (nonatomic,strong)NSArray *picNameArray;
@end
@implementation RH_DepositeChooseMoneyCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return HomeCategoryItemsCellHeight+50;
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
    //图片名称数组
    _picNameArray = @[@"100",@"200",@"500",@"1000",@"5000"];
    [self setupUI];
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.dataModel = ConvertToClassPointer(RH_DepositePaydataModel, context);
    [self.collectionView reloadData];
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
//    flowLayout.itemSize =CGSizeMake(60, 60);
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.backgroundColor = [UIColor whiteColor] ;
    CGRect frame = _collectionView.frame;
    frame.size.height =HomeCategoryItemsCellHeight;
    _collectionView.frame  = frame;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10) ;
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
    [cell updateViewWithInfo:nil context:self.picNameArray[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(depositeChooseMoneyCell:)){
        if (indexPath.item==0) {
            [self.delegate depositeChooseMoneyCell:100] ;
        }
        else if (indexPath.item==1) {
            [self.delegate depositeChooseMoneyCell:200] ;
        }
        else if (indexPath.item==2) {
            [self.delegate depositeChooseMoneyCell:500] ;
        }
       else if (indexPath.item==3) {
            [self.delegate depositeChooseMoneyCell:1000] ;
        }
       else if (indexPath.item==4) {
            [self.delegate depositeChooseMoneyCell:5000] ;
        }
    }
}

@end
