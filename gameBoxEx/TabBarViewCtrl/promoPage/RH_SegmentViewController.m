//
//  RH_SegmentViewController.m
//  gameBoxEx
//
//  Created by barca on 2018/9/29.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_SegmentViewController.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_ExampleViewController.h"
#define HEADBTN_TAG                 10000
#define Default_BottomLineColor     [UIColor redColor]
#define Default_BottomLineHeight    2
#define Default_ButtonHeight        55
#define Default_TitleColor          [UIColor blackColor]
#define Default_HeadViewBackgroundColor  [UIColor whiteColor]
#define Default_FontSize            16
#define MainScreenWidth             [[UIScreen mainScreen]bounds].size.width
#define MainScreenHeight            [[UIScreen mainScreen]bounds].size.height
@interface RH_SegmentViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *headerView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic,strong) NSMutableArray *modelArr;
@end

@implementation RH_SegmentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSegment
{
    [self addButtonInScrollHeader:self.modelArr];
    [self addContentViewScrollView:_subViewControllers];
}
- (void)addButtonInScrollHeader:(NSArray *)titleArray
{
    CGFloat iphoneHeight = iPhoneX?88:64;
    self.headerView.frame = CGRectMake(0, iphoneHeight, MainScreenWidth, self.buttonHeight);
    if (_segmentHeaderType == 0) {
        self.headerView.contentSize = CGSizeMake(self.buttonWidth * titleArray.count, self.buttonHeight);
    }
    else {
        self.headerView.contentSize = CGSizeMake(MainScreenWidth, self.buttonHeight);
    }
    [self.view addSubview:self.headerView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        RH_DiscountActivityTypeModel *model = titleArray[index];
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(self.buttonWidth * index, 0, self.buttonWidth, self.buttonHeight);
        [segmentBtn setTitle:model.mActivityTypeName forState:UIControlStateNormal];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        segmentBtn.tag = index + HEADBTN_TAG;
        segmentBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [segmentBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [segmentBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:segmentBtn];
        if (index == 0) {
            segmentBtn.selected = YES;
            self.selectIndex = segmentBtn.tag;
        }
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHeight - self.bottomLineHeight, self.buttonWidth, self.bottomLineHeight)];
    _lineView.backgroundColor = self.bottomLineColor;
    [self.headerView addSubview:_lineView];
}

/*!
 *  @brief  根据传入的viewController数组，将viewController的view添加到显示内容的scrollView
 *
 *  @param subViewControllers  viewController数组
 */
- (void)addContentViewScrollView:(NSArray *)subViewControllers
{
    CGFloat iphoneHeight = iPhoneX?88:64;
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.buttonHeight + iphoneHeight, MainScreenWidth, MainScreenHeight - self.buttonHeight)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth * subViewControllers.count, MainScreenHeight - self.buttonHeight);
    [_mainScrollView setPagingEnabled:YES];
    if (_segmentControlType == 0) {
        _mainScrollView.scrollEnabled = YES;
    }
    else {
        _mainScrollView.scrollEnabled = NO;
    }
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    [subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * MainScreenWidth, 0, MainScreenWidth, _mainScrollView.frame.size.height - 60);
        [_mainScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
}
- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

- (void)btnClick:(UIButton *)button
{
    [_mainScrollView scrollRectToVisible:CGRectMake((button.tag - HEADBTN_TAG) *MainScreenWidth, 0, MainScreenWidth, _mainScrollView.frame.size.height) animated:YES];
    [self didSelectSegmentIndex:button.tag];
}

- (void)didSelectSegmentIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.selectIndex];
    btn.selected = NO;
    self.selectIndex = index;
    UIButton *currentSelectBtn = (UIButton *)[self.view viewWithTag:index];
    currentSelectBtn.selected = YES;
    CGRect rect = self.lineView.frame;
    rect.origin.x = (index - HEADBTN_TAG) * _buttonWidth;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = rect;
    }];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        float xx = scrollView.contentOffset.x * (_buttonWidth / MainScreenWidth) - _buttonWidth;
        [_headerView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _headerView.frame.size.height) animated:YES];
        NSInteger currentIndex = scrollView.contentOffset.x / MainScreenWidth;
        [self didSelectSegmentIndex:currentIndex + HEADBTN_TAG];
    }
    RH_ExampleViewController *vc =   _subViewControllers[self.selectIndex - 10000];
    [vc initWithIndex:self.selectIndex ActivityTypeModel:self.modelArr[self.selectIndex-10000]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    float xx = scrollView.contentOffset.x * (_buttonWidth / MainScreenWidth) - _buttonWidth;
    [_headerView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _headerView.frame.size.height) animated:YES];
    RH_ExampleViewController *vc =   _subViewControllers[self.selectIndex - 10000];
    [vc initWithIndex:self.selectIndex ActivityTypeModel:self.modelArr[self.selectIndex-10000]];
}

#pragma mark - setter/getter
- (UIScrollView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc] init];
        [_headerView setShowsVerticalScrollIndicator:NO];
        [_headerView setShowsHorizontalScrollIndicator:NO];
        _headerView.bounces = NO;
        _headerView.backgroundColor = self.headViewBackgroundColor;
    }
    return _headerView;
}

- (UIColor *)headViewBackgroundColor
{
    if (_headViewBackgroundColor == nil) {
        _headViewBackgroundColor = Default_HeadViewBackgroundColor;
    }
    return _headViewBackgroundColor;
}

- (UIColor *)titleColor
{
    if (_titleColor == nil) {
        _titleColor = Default_TitleColor;
    }
    return _titleColor;
}

- (UIColor *)titleSelectedColor
{
    if (_titleSelectedColor == nil) {
        _titleSelectedColor = Default_TitleColor;
    }
    return _titleSelectedColor;
}

- (CGFloat)fontSize
{
    if (_fontSize == 0) {
        _fontSize = Default_FontSize;
    }
    return _fontSize;
}

- (CGFloat)buttonWidth
{
    if (_buttonWidth == 0) {
        _buttonWidth = MainScreenWidth / 6;
    }
    return _buttonWidth;
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight == 0) {
        _buttonHeight = Default_ButtonHeight;
    }
    return _buttonHeight;
}

- (CGFloat)bottomLineHeight
{
    if (_bottomLineHeight == 0) {
        _bottomLineHeight = Default_BottomLineHeight;
    }
    return _bottomLineHeight;
}

- (UIColor *)bottomLineColor
{
    if (_bottomLineColor == nil) {
        _bottomLineColor = Default_BottomLineColor;
    }
    return _bottomLineColor;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    [self.modelArr addObjectsFromArray:titleArray];
}

-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
@end
