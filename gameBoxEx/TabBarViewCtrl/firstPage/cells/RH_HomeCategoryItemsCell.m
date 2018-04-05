//
//  RH_HomeCategoryItemsCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategoryItemsCell.h"
#import "RH_HomeCategoryItemSubCell.h"
#import "coreLib.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_LotteryInfoModel.h"

#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-30)/3.0)
#define HomeCategoryItemsCellHeight                     102.0f

@interface RH_HomeCategoryItemsCell()<UICollectionViewDelegate,UICollectionViewDataSource>;
@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@property (nonatomic,strong) NSArray *itemsList ;
@end

@implementation RH_HomeCategoryItemsCell
@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context) ;
    NSInteger number = array.count ;
    NSInteger lines = MAX(number%3?(number/3)+1:(number/3) ,3);
    
    return HomeCategoryItemsCellHeight * lines + (lines-1)*5 + 25.0f ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
    self.itemsList = ConvertToClassPointer(NSArray, context) ;
    [self.collectionView reloadData] ;
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.f;
        flowLayout.minimumInteritemSpacing = 5.0f ;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 10, 0.f);
        flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellHeight) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.contentView.frameWidth,
                                                                             self.contentView.frameHeigh)
                                             collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        if ([THEMEV3 isEqualToString:@"black"]) {
            _collectionView.backgroundColor = colorWithRGB(21, 21, 21);
        }
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
        [_collectionView registerCellWithClass:[RH_HomeCategoryItemSubCell class]];
    }
    return _collectionView;
}

#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger number = self.itemsList.count ;
    return (number%3?(number/3)+1:(number/3)) ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger leftItems = self.itemsList.count - section*3 ;
    return MIN(3, leftItems) ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeCategoryItemSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeCategoryItemSubCell defaultReuseIdentifier] forIndexPath:indexPath];
    [cell updateViewWithInfo:nil context:self.itemsList[indexPath.section*3+indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(homeCategoryItemsCellDidTouchItemCell:DataModel:)){
        [self.delegate homeCategoryItemsCellDidTouchItemCell:self DataModel:self.itemsList[indexPath.section*3+indexPath.item]] ;
    }
}

@end
