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

#define HomeCategoryItemsCellWidth                     floorf((MainScreenW-40)/3.0)

@interface RH_HomeCategoryItemsCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) IBOutlet CLSegmentedControl *segmentHeaderView ;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *layoutSegmentHeaderViewHeight ;
@property (nonatomic,strong,readonly) UICollectionView *collectionView ;
@end

@implementation RH_HomeCategoryItemsCell
@synthesize collectionView = _collectionView ;
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return HomeCategoryItemsCellWidth * 3 + (3-1)*10 + 20.0f + 37.0f ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = [UIColor clearColor] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0f) ;
    [self.contentView addSubview:self.collectionView] ;
    [self.collectionView reloadData] ;
    
    //test added
    [self configSegmentView:self.segmentHeaderView] ;
    
    [self.segmentHeaderView addSectionsWithTitles:@[@"天天彩票",@"BB彩票",@"KG彩票"]] ;
    self.segmentHeaderView.selectedSectionIndex = 0 ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
}

#pragma mark-
-(void)configSegmentView:(CLSegmentedControl*)segmentControl
{
    segmentControl.backgroundColor = [UIColor clearColor] ;
    segmentControl.separatorLineWidth = 0.f;
    segmentControl.borderMask = CLBorderMarkBottom;
    segmentControl.borderColor = [UIColor grayColor];
    segmentControl.apportionsSelectedIndicatorLineByContent = YES;
    segmentControl.showSelectedIndicatorLine = YES;
    segmentControl.selectedIndicatorLineInset = UIEdgeInsetsMake(0.F, -8.F, 0.F, -8.F);
    segmentControl.selectedIndicatorLineColor = [UIColor blueColor];
    segmentControl.selectedIndicatorLineWidth = 2.f;
    [segmentControl setTextColor:colorWithRGB(124, 124, 124) forState:CLSegmentedControlSectionStateNormal];
    [segmentControl setTextColor:colorWithRGB(53, 118, 185) forState:CLSegmentedControlSectionStateSelected];
    segmentControl.textFont = [UIFont systemFontOfSize:14.f];
    [segmentControl addTarget:self action:@selector(_segmentedControlHandle:) forControlEvents:UIControlEventValueChanged];
}

-(void)_segmentedControlHandle:(id)sender
{
    
}

#pragma mark-
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5.f;
        flowLayout.minimumInteritemSpacing = 5.0f ;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0.f, 5, 0.f);
        flowLayout.itemSize = CGSizeMake(HomeCategoryItemsCellWidth, HomeCategoryItemsCellWidth) ;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             self.layoutSegmentHeaderViewHeight.constant,
                                                                             self.contentView.frameWidth,
                                                                             self.contentView.frameHeigh - self.layoutSegmentHeaderViewHeight.constant)
                                             collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _collectionView.backgroundColor = [UIColor clearColor];
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
    return 3 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section<2?3:2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RH_HomeCategoryItemSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RH_HomeCategoryItemSubCell defaultReuseIdentifier] forIndexPath:indexPath];

    [cell updateViewWithInfo:nil context:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
