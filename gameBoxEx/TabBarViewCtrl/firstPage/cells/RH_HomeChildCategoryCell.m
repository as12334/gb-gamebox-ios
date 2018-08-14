//
//  RH_HomeChildCategoryCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeChildCategoryCell.h"
#import "RH_HomeChildCategorySubCell.h"
#import "coreLib.h"
#import "RH_LotteryAPIInfoModel.h"

#define HomeChildCategoryCellHeight                    50.0f
#define HomeChildCategoryCellWidth                     floorf((MainScreenW-20)/3.0)

@interface RH_HomeChildCategoryCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray  *subCategoryList ;
@property (nonatomic,strong) IBOutlet UICollectionView *collectionView ;
@property (nonatomic,strong) IBOutlet UIView *lineView ;

//选择指示器
@property(nonatomic,strong,readonly) CALayer * selectionIndicater;
@end

@implementation RH_HomeChildCategoryCell
@synthesize collectionView = _collectionView ;
@synthesize selectionIndicater = _selectionIndicater;
@synthesize selectedIndex = _selectedIndex ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return  HomeChildCategoryCellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.contentView.backgroundColor = [UIColor clearColor];
     self.lineView.backgroundColor = colorWithRGB(226, 226, 226) ;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.contentView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
        self.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
        self.lineView.backgroundColor = colorWithRGB(102, 102, 102) ;
    }
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    _selectedIndex = 0 ;
    self.collectionView.backgroundColor = [UIColor redColor];
    [self configureCollection:self.collectionView] ;
    
   
    self.lineView.whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0).whc_Height(1) ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.subCategoryList = ConvertToClassPointer(NSArray, context) ;
    [self.collectionView reloadData] ;
    if (_selectedIndex<0 || _selectedIndex>=self.subCategoryList.count){
        _selectedIndex = 0 ;
    }
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft] ;
}

#pragma mark-
-(NSInteger)selectedIndex
{
    [self _updateSelectionIndicater:YES] ;
    return _selectedIndex ;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    RH_HomeChildCategorySubCell * cell = (RH_HomeChildCategorySubCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
    cell.selected = YES;
}

#pragma mark -
-(void)layoutSubviews
{
    [super layoutSubviews] ;
    if (_selectionIndicater==nil){
        [self _updateSelectionIndicater:NO] ;
    }else {
        [self _updateSelectionIndicater:YES];
    }
}

- (CALayer *)selectionIndicater
{
    if (!_selectionIndicater) {
        _selectionIndicater = [[CALayer alloc] init];
        if ([THEMEV3 isEqualToString:@"green"]) {
//            _selectionIndicater.backgroundColor = [UIColor greenColor].CGColor;
            _selectionIndicater.backgroundColor = colorWithRGB(27, 117, 217).CGColor;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            _selectionIndicater.backgroundColor = colorWithRGB(27, 117, 217).CGColor;
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Blue.CGColor;
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Orange.CGColor;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White.CGColor;
        }else{
            _selectionIndicater.backgroundColor = colorWithRGB(27, 117, 217).CGColor;
        }
        
        [self.collectionView.layer addSublayer:_selectionIndicater];
    }
    
    return _selectionIndicater;
}

- (void)_updateSelectionIndicater:(BOOL)animated
{
    NSIndexPath * indexPathForSelectedItem = [self.collectionView.indexPathsForSelectedItems firstObject];
    
    [CATransaction begin];
    [CATransaction setDisableActions:!indexPathForSelectedItem || !animated];
    [CATransaction setAnimationDuration:0.5];
    
    if (indexPathForSelectedItem == nil) {
        self.selectionIndicater.frame = CGRectZero;
    }else {
        
        //获取选中的cell的位置
        CGRect cellFrame = [self.collectionView layoutAttributesForItemAtIndexPath:indexPathForSelectedItem].frame;
//        NSLog(@"%f,%f,%f,%f",cellFrame.origin.x,cellFrame.origin.y,cellFrame.size.height,cellFrame.size.width) ;
        //设置选择指示器位置
        self.selectionIndicater.frame = CGRectMake(CGRectGetMinX(cellFrame), CGRectGetMaxY(cellFrame) - 2.f, CGRectGetWidth(cellFrame), 2.f);
    }
    
    [CATransaction commit];
}

#pragma mark-
-(void)configureCollection:(UICollectionView*)collectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 0.0f, 0.f);
    flowLayout.itemSize = CGSizeMake(HomeChildCategoryCellWidth, HomeChildCategoryCellHeight) ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionView.collectionViewLayout = flowLayout ;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = NO ;
    collectionView.allowsSelection = YES ;
    [collectionView registerCellWithClass:[RH_HomeChildCategorySubCell class]];
}


#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subCategoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeChildCategorySubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeChildCategorySubCell defaultReuseIdentifier] forIndexPath:indexPath];

    [cell updateViewWithInfo:nil context:self.subCategoryList[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.item ;
    [self _updateSelectionIndicater:YES] ;
    ifRespondsSelector(self.delegate, @selector(homeChildCategoryCellDidChangedSelectedIndex:)){
        [self.delegate homeChildCategoryCellDidChangedSelectedIndex:self] ;
    }
}

@end
