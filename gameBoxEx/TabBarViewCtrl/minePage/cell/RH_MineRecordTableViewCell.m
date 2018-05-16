//
//  RH_MineRecordTableViewCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineRecordTableViewCell.h"
#import "coreLib.h"
#import "RH_MineRecordStaticCell.h"
#import "RH_MainTabBarController.h"
#import "RH_UserInfoManager.h"
#import "RH_CustomViewController.h"
#import "RH_ApplyDiscountViewController.h"
#define cellHeight                  65.0f
#define lineCellCount                2

@interface RH_MineRecordTableViewCell()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet CLStaticCollectionView *staticCollectionView;
@property (nonatomic,strong) NSArray *rowsList ;
@end

@implementation RH_MineRecordTableViewCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    NSArray *rows = [info rowsInfo] ;
    return ((rows.count%lineCellCount)?(rows.count/lineCellCount)+1: (rows.count/lineCellCount))*cellHeight ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.staticCollectionView.allowCellSeparationLine = NO ;
    self.staticCollectionView.allowSectionSeparationLine = YES ;
    self.staticCollectionView.averageCellWidth = YES ;
    self.staticCollectionView.dataSource = self ;
    self.staticCollectionView.delegate = self ;
    self.staticCollectionView.separationLineWidth = PixelToPoint(1) ;
    self.staticCollectionView.separationLineColor = colorWithRGB(219, 219, 219) ;
    self.staticCollectionView.separationLineInset = UIEdgeInsetsMake(5, 0, 5, 0) ;
    
    self.staticCollectionView.userInteractionEnabled = YES ;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.rowsList = info.rowsInfo ;
    [self.staticCollectionView reloadData] ;
    
}

#pragma mark--
- (NSUInteger)numberOfSectionInStaticCollectionView:(CLStaticCollectionView *)collectionView
{
    return ((self.rowsList.count%lineCellCount)?(self.rowsList.count/lineCellCount)+1: (self.rowsList.count/lineCellCount)) ;
}

- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
   return lineCellCount;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView
                              cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section *lineCellCount + indexPath.item ;
    if (index<self.rowsList.count){
        RH_MineRecordStaticCell * cell = [collectionView dequeueReusableCellWithIdentifier:[RH_MineRecordStaticCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [RH_MineRecordStaticCell createInstance]  ;
            [cell setupReuseIdentifier:[RH_MineRecordStaticCell defaultReuseIdentifier]] ;
        }
        [cell updateCellWithInfo:[self.rowsList objectAtIndex:index] context:nil] ;
        return  cell ;
    }
    
    return nil ;
}

- (BOOL)staticCollectionView:(CLStaticCollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(mineRecordTableViewCellDidTouchCell:CellInfo:)){
        [self.delegate mineRecordTableViewCellDidTouchCell:self CellInfo:self.rowsList[indexPath.section*lineCellCount + indexPath.item]] ;
    }
    
    return NO ;
}

@end
