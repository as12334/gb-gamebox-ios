//
//  RH_GameListHeaderView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListHeaderView.h"
#import "coreLib.h"
#import "RH_GameCategoryCell.h"

@interface RH_GameListHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) UICollectionView *collectionTypeView ;
//选择指示器
@property(nonatomic,strong,readonly) CALayer * selectionIndicater;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong) NSArray *arrayTypeList ;
@end

@implementation RH_GameListHeaderView

@synthesize collectionTypeView = _collectionTypeView ;
@synthesize selectedIndex = _selectedIndex ;
@synthesize selectionIndicater = _selectionIndicater;

-(instancetype)init
{
    self = [super init] ;
    if (self){
        self.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self addSubview:self.collectionTypeView] ;
        
        [self.collectionTypeView reloadData] ;
        _selectedIndex = 0 ;
        
    }
    return self ;
}

-(void)updateView:(NSArray*)typeList
{
    self.arrayTypeList = ConvertToClassPointer(NSArray, typeList) ;
    [self.collectionTypeView reloadData] ;
    [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally] ;
    [self setSelectedIndex:0] ;
    [self _updateSelectionIndicater:YES] ;
    ifRespondsSelector(self.delegate, @selector(gameListHeaderViewDidChangedSelectedIndex:SelectedIndex:)){
        [self.delegate gameListHeaderViewDidChangedSelectedIndex:self SelectedIndex:_selectedIndex] ;
    }
}

-(NSDictionary *)typeModelWithIndex:(NSInteger)index
{
    if (index>=0 && index <self.arrayTypeList.count){
        return self.arrayTypeList[index] ;
    }
    
    return nil ;
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
        
        if ([THEMEV3 isEqualToString:@"green"]){
//            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Green.CGColor;
           _selectionIndicater.backgroundColor = colorWithRGB(15, 167, 115).CGColor;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
             _selectionIndicater.backgroundColor = colorWithRGB(22, 142, 246).CGColor;
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Blue.CGColor;
            
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor_Orange.CGColor;
        }else{
             _selectionIndicater.backgroundColor = RH_NavigationBar_BackgroundColor.CGColor;
        }

        [self.collectionTypeView.layer addSublayer:_selectionIndicater];
    }
    
    return _selectionIndicater;
}

- (void)_updateSelectionIndicater:(BOOL)animated
{
    NSIndexPath * indexPathForSelectedItem = [self.collectionTypeView.indexPathsForSelectedItems firstObject];
    for (NSIndexPath *indexPath in self.collectionTypeView.indexPathsForVisibleItems) {
        RH_GameCategoryCell *cell = ConvertToClassPointer(RH_GameCategoryCell, [self.collectionTypeView cellForItemAtIndexPath:indexPath]);
        if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
            [cell setTitleLabelTextColor:[UIColor whiteColor]];
        }else{
            [cell setTitleLabelTextColor:colorWithRGB(51, 51, 51)];
        }
    }
    NSIndexPath *index = self.collectionTypeView.indexPathsForSelectedItems.firstObject;
    RH_GameCategoryCell *cell = ConvertToClassPointer(RH_GameCategoryCell, [self.collectionTypeView cellForItemAtIndexPath:index]);
    if ([THEMEV3 isEqualToString:@"green"]){
//        [cell setTitleLabelTextColor:RH_NavigationBar_BackgroundColor_Green];
        [cell setTitleLabelTextColor:colorWithRGB(15, 167, 115)];
    }else if ([THEMEV3 isEqualToString:@"red"]){
        [cell setTitleLabelTextColor:colorWithRGB(242, 32, 95)];
        
    }else if ([THEMEV3 isEqualToString:@"black"]){
        [cell setTitleLabelTextColor:colorWithRGB(22, 142, 246)];
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        [cell setTitleLabelTextColor:RH_NavigationBar_BackgroundColor_Blue];
        
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        [cell setTitleLabelTextColor:RH_NavigationBar_BackgroundColor_Orange];
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        [cell setTitleLabelTextColor:RH_NavigationBar_BackgroundColor_Coffee_Black];
    }else{
        [cell setTitleLabelTextColor:colorWithRGB(23, 102, 187)];
    }
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:!indexPathForSelectedItem || !animated];
    [CATransaction setAnimationDuration:0.5];
    
    if (indexPathForSelectedItem == nil) {
        self.selectionIndicater.frame = CGRectZero;
    }else {
        
        //获取选中的cell的位置
        CGRect cellFrame = [self.collectionTypeView layoutAttributesForItemAtIndexPath:indexPathForSelectedItem].frame;
        
        //设置选择指示器位置
        self.selectionIndicater.frame = CGRectMake(CGRectGetMinX(cellFrame), CGRectGetMaxY(cellFrame) - 1.5f, CGRectGetWidth(cellFrame), 1.5f);
        if (!self.lineView) {
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cellFrame) - 1.f, [UIScreen mainScreen].bounds.size.width, 1)];
            self.lineView.backgroundColor = colorWithRGB(71, 71, 71);
            [self addSubview:self.lineView];
        }
        
    }
    
    [CATransaction commit];
}


#pragma mark -
-(UICollectionView *)collectionTypeView
{
    if (!_collectionTypeView){
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 10.f, 0.0f, 10.0f) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        _collectionTypeView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout] ;
        _collectionTypeView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ;
        _collectionTypeView.delegate = self ;
        _collectionTypeView.dataSource = self ;
        _collectionTypeView.backgroundColor = [UIColor clearColor] ;
        if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
            _collectionTypeView.backgroundColor = [UIColor blackColor] ;
        }
        
        _collectionTypeView.showsHorizontalScrollIndicator = NO;
        [_collectionTypeView registerCellWithClass:[RH_GameCategoryCell class]] ;
        
        
    }
    
    return _collectionTypeView ;
}

#pragma mark-
-(NSInteger)allTypes
{
    return self.arrayTypeList.count ;
}

-(NSInteger)selectedIndex
{
    return _selectedIndex ;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex!=selectedIndex){
        _selectedIndex = selectedIndex ;
        [self.collectionTypeView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]
                                              animated:YES
                                        scrollPosition:UICollectionViewScrollPositionCenteredHorizontally] ;
        [self _updateSelectionIndicater:YES];
    }
}

-(CGSize)containSize
{
    return self.collectionTypeView.contentSize ;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.arrayTypeList.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_GameCategoryCell *typeCell = [self.collectionTypeView dequeueReusableCellWithReuseIdentifier:[RH_GameCategoryCell defaultReuseIdentifier] forIndexPath:indexPath];
    [typeCell updateViewWithInfo:ConvertToClassPointer(NSDictionary, self.arrayTypeList[indexPath.item]) context:nil] ;
//    if (![THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
//        typeCell.labTitle.textColor = [UIColor whiteColor];
//    }
    
    return typeCell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_GameCategoryCell sizeForViewWithInfo:ConvertToClassPointer(NSDictionary, self.arrayTypeList[indexPath.item])
                                  containerViewSize:collectionView.bounds.size
                                            context:nil] ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:indexPath.item] ;
    [self _updateSelectionIndicater:YES] ;
    ifRespondsSelector(self.delegate, @selector(gameListHeaderViewDidChangedSelectedIndex:SelectedIndex:)){
        [self.delegate gameListHeaderViewDidChangedSelectedIndex:self SelectedIndex:_selectedIndex] ;
    }
}

@end
