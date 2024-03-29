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
#import "RH_HomePageModel.h"

#define HomeCategoryCellHeight                    62
#define HomeCategoryCellWidth                       70.0f

@interface RH_HomeCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) RH_HomePageModel *homePageModel ;
//@property (nonatomic,strong) IBOutlet CLBorderView *collectionBGView ;
@property (nonatomic,strong) IBOutlet UICollectionView *collectionView ;
@end

@implementation RH_HomeCategoryCell
@synthesize collectionView = _collectionView ;
@synthesize selectedIndex = _selectedIndex  ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return  HomeCategoryCellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    _selectedIndex = 0 ;
    
//    self.collectionBGView.backgroundColor = colorWithRGB(247, 247, 247) ;
//    self.collectionBGView.borderMask = CLBorderMarkBottom ;
//    self.collectionBGView.borderColor = colorWithRGB(226, 226, 226) ;
//    self.collectionBGView.borderWidth = 1.0f ;
//    self.collectionBGView.borderLineInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    UIImageView *imageB = [UIImageView new];
    [self.contentView insertSubview:imageB atIndex:0];
    imageB.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
    imageB.image = ImageWithName(@"NAV-BG");
    [self configureCollection:self.collectionView] ;
    
    UIView *line = [UIView new];
    [self.contentView insertSubview:line belowSubview:self.collectionView] ;
    line.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Height(1) ;
    line.backgroundColor = colorWithRGB(226, 226, 226);
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.homePageModel = ConvertToClassPointer(RH_HomePageModel, context) ;
    [self.collectionView reloadData] ;
    if (_selectedIndex<0 || _selectedIndex>=self.homePageModel.mLotteryCategoryList.count){
        _selectedIndex = 0 ;
    }
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft] ;
}

#pragma mark-
-(void)configureCollection:(UICollectionView*)collectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, -2.f, 0.0f, -2.f);
    flowLayout.itemSize = CGSizeMake(HomeCategoryCellWidth, HomeCategoryCellHeight) ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionView.collectionViewLayout = flowLayout ;
    collectionView.backgroundColor = colorWithRGB(247, 247, 247);
    collectionView.bounces = NO;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        collectionView.backgroundColor = colorWithRGB(37, 37, 37);
    }
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = NO ;
    collectionView.allowsSelection = YES ;
    [collectionView registerCellWithClass:[RH_HomeCategorySubCell class]];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homePageModel.mLotteryCategoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeCategorySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeCategorySubCell defaultReuseIdentifier] forIndexPath:indexPath];
    [cell updateViewWithInfo:nil context:self.homePageModel.mLotteryCategoryList[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (RH_HomeCategorySubCell *item in collectionView.visibleCells) {
        [item setSelected:YES];
    }
    _selectedIndex = indexPath.item ;
    
    ifRespondsSelector(self.delegate, @selector(homeCategoryCellDidChangedSelected:index:)){
        [self.delegate homeCategoryCellDidChangedSelected:self index:indexPath.item] ;
    }
}

@end
