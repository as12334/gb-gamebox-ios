//
//  RH_FirstBigViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FirstBigViewCell.h"
#import "coreLib.h"
#import "RH_FirstBigCellHeadView.h"
#import "RH_AwardRuleCollectionViewCell.h"
#import "RH_ShareRecordCollectionViewCell.h"

@interface RH_FirstBigViewCell ()<firstBigCellHeadViewDelegate,CLPageViewDelegate,CLPageViewDatasource>
@property(nonatomic,strong,readonly)RH_FirstBigCellHeadView *headView ;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ;

@end
@implementation RH_FirstBigViewCell
@synthesize headView = _headView ;
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        UIView *bgView = [[UIView alloc] init ];
        [self.contentView addSubview:bgView];
        bgView.layer.cornerRadius = 5.f;
        bgView.layer.masksToBounds = YES ;
        bgView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
        bgView.backgroundColor = colorWithRGB(242, 242, 242) ;

        [bgView addSubview:self.headView];
        self.headView.whc_TopSpace(0).whc_Width(MainScreenW).whc_CenterX(0).whc_Height(63) ;
        
        NSArray *typeList =@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
        [self.headView updateView:typeList] ;
       
        //分页视图
        [bgView addSubview:self.pageView];
        //注册复用
        [self.pageView registerCellForPage:[RH_AwardRuleCollectionViewCell class] andReuseIdentifier:[RH_AwardRuleCollectionViewCell defaultReuseIdentifier]] ;
        [self.pageView registerCellForPage:[RH_ShareRecordCollectionViewCell class] andReuseIdentifier:[RH_ShareRecordCollectionViewCell defaultReuseIdentifier]] ;
        
        //设置索引
        self.pageView.dispalyPageIndex =  _selectedIndex ;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.backgroundView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.backgroundView.frame = frame;
    frame = self.contentView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.contentView.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark --- 头视图
-(RH_FirstBigCellHeadView *)headView
{
    if (!_headView) {
        _headView = [RH_FirstBigCellHeadView createInstance];
        _headView.delegate= self;
        _headView.selectedIndex = self.selectedIndex;
    }
    return _headView;
}
#pragma mark 分页视图
#pragma mark 分页视图
-(CLPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[CLPageView alloc] initWithFrame:CGRectMake(0, 60, screenSize().width-100, 200)];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        _pageView.delegate = self ;
        _pageView.dataSource = self ;
        _pageView.pageMargin = 5.0f;
    }
    return _pageView;
}
#pragma mark --初始化字典
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
}
- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return 2  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    if (pageIndex ==0)
    {
        RH_AwardRuleCollectionViewCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_AwardRuleCollectionViewCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        return cell;
    }
    else if (pageIndex==1){
        RH_ShareRecordCollectionViewCell* cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ShareRecordCollectionViewCell defaultReuseIdentifier] forPageIndex:pageIndex];
        //                cell.delegate=self;
          [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        return cell;
    }
    return nil;
    
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    self.headView.segmentedControl.selectedSegmentIndex = pageIndex;
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex
{
//     self.headView.segmentedControl.selectedSegmentIndex = pageIndex;
}

- (void)pageViewWillReloadPages:(CLPageView *)pageView {
    
}

#pragma mark-pageload context
- (CLPageLoadDatasContext *)_pageLoadDatasContextForPageAtIndex:(NSUInteger)pageIndex
{
    NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
    CLPageLoadDatasContext * context = self.dictPageCellDataContext[key];
    if (context == nil) {
        context = [[CLPageLoadDatasContext alloc] initWithDatas:nil context:nil];
    }
    
    return context;
}

- (void)_savePageLoadDatasContextAtPageIndex:(NSUInteger)pageIndex
{
    RH_AwardRuleCollectionViewCell * cell = [self.pageView cellForPageAtIndex:0];
    RH_ShareRecordCollectionViewCell *mineCell = [self.pageView cellForPageAtIndex:1];
   
    if (cell != nil) {
        CLPageLoadDatasContext * context = (id)[cell currentPageContext];
        NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
        if (context) {
            [self.dictPageCellDataContext setObject:context forKey:key] ;
        }else {
            [self.dictPageCellDataContext removeObjectForKey:key];
        }
    }
    else if (mineCell != nil) {
        CLPageLoadDatasContext * context = (id)[mineCell currentPageContext];
        NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
        if (context) {
            [self.dictPageCellDataContext setObject:context forKey:key] ;
        }else {
            [self.dictPageCellDataContext removeObjectForKey:key];
        }
    }
}

#pragma mark - firstBigCellHeadViewDelegate
-(void)firstBigCellHeadViewDidChangedSelectedIndex:(RH_FirstBigCellHeadView *)firstBigCellHeadView SelectedIndex:(NSInteger)selectedIndex
{
    self.headView.segmentedControl.selectedSegmentIndex = selectedIndex;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
