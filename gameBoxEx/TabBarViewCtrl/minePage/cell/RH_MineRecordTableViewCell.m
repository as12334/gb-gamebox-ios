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
#define cellHeight                  50.0f
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
    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    if (!appDelegate.isLogin){
        showAlertView(@"提示信息", @"该操作需要用户登入");
        return  NO ;
    }
    
    NSInteger index = indexPath.section * lineCellCount + indexPath.item ;
    NSDictionary *dict = ConvertToClassPointer(NSDictionary, [self.rowsList objectAtIndex:index]) ;
    UIViewController *viewCtrl = [dict targetViewControllerWithContext:[dict targetContext]] ;
    if ([viewCtrl isKindOfClass:[RH_ApplyDiscountViewController class]]) {
        RH_ApplyDiscountViewController *discountVC = ConvertToClassPointer(RH_ApplyDiscountViewController, viewCtrl);
        [discountVC setTitle:@"消息中心"];
    }
    if (viewCtrl){
        [self showViewController:viewCtrl] ;
    }else{
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        NSString *code = [dict stringValueForKey:@"code"] ;
        if ([code isEqualToString:@"transfer"]){
            appDelegate.customUrl = @"/transfer/index.html" ;
            [self showViewController:[RH_CustomViewController viewController]] ;
        }else if ([code isEqualToString:@"gameNotice"]){
            appDelegate.customUrl = @"/message/gameNotice.html?isSendMessage=true" ;
            [self showViewController:[RH_CustomViewController viewController]] ;
        }else if ([code isEqualToString:@"bankCard"]){
            appDelegate.customUrl = @"/bankCard/page/addCard.html" ;
            [self showViewController:[RH_CustomViewController viewController]] ;
        }else if ([code isEqualToString:@"btc"]){
            appDelegate.customUrl = @"/bankCard/page/addBtc.html" ;
            [self showViewController:[RH_CustomViewController viewController]] ;
        }else if ([code isEqualToString:@"withdraw"]){
             appDelegate.customUrl = @"/wallet/withdraw/index.html" ;
            [self showViewController:[RH_CustomViewController viewController]] ;
        }
    }
    
    return NO ;
}

@end
