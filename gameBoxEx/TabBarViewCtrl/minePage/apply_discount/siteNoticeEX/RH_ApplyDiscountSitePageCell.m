//
//  RH_ApplyDiscountSitePageCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSitePageCell.h"
#import "coreLib.h"
#import "RH_ApplyDiscountSiteSystemCell.h"
#import "RH_ApplyDiscountSiteMineCell.h"
#import "RH_ApplyDiscountSiteSendCell.h"
@interface RH_ApplyDiscountSitePageCell ()<CLPageViewDelegate,CLPageViewDatasource>
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong)UIButton *chooseBtn;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ;
@end

@implementation RH_ApplyDiscountSitePageCell
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        [self.pageView registerCellForPage:[RH_ApplyDiscountSiteSystemCell class] andReuseIdentifier:[RH_ApplyDiscountSiteSystemCell defaultReuseIdentifier]];
       [self.pageView registerCellForPage:[RH_ApplyDiscountSiteMineCell class] andReuseIdentifier:[RH_ApplyDiscountSiteMineCell defaultReuseIdentifier]];
        [self.pageView registerCellForPage:[RH_ApplyDiscountSiteSendCell class] andReuseIdentifier:[RH_ApplyDiscountSiteSendCell defaultReuseIdentifier]];
        self.backgroundColor = colorWithRGB(242, 242, 242);
        //分页视图
        [self.contentView addSubview:self.pageView];
        self.pageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth ;
        //设置索引
        self.pageView.dispalyPageIndex =  0 ;
        //加上三个按钮
        NSArray *btnTitleArray = @[@"系统消息",@"我的消息",@"发送消息"];
        for (int i = 0; i<3; i++) {
            UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+70*i, 10, 60, 30);
            btn.backgroundColor = [UIColor lightGrayColor];
            [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = btn.bounds;
            maskLayer.path = maskPath.CGPath;
            btn.layer.mask = maskLayer;
            btn.tag  = i+10;
            [btn addTarget:self action:@selector(selectedChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:colorWithRGB(200, 200, 200)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (i==0) {
                btn.backgroundColor = colorWithRGB(23, 102, 187);
                btn.selected = YES;
                self.chooseBtn = btn;
                
            }
            [self addSubview:btn];
        }
        CLBorderView *borderView = [[CLBorderView alloc]initWithFrame:CGRectMake(10,40, self.frameWidth-20, 1)];
        borderView.backgroundColor  = colorWithRGB(23, 102, 187);
        [self addSubview:borderView];
    }else {
        [self updateWithContext:context];
    }
}

#pragma mark 选择按钮的点击事件
-(void)selectedChooseBtn:(UIButton *)button
{
    if (!button.isSelected) {
        self.chooseBtn.selected = !self.chooseBtn.selected;
        self.chooseBtn.backgroundColor = colorWithRGB(200, 200, 200);
        button.selected = !button.selected;
        button.backgroundColor = colorWithRGB(23, 102, 187);
        self.chooseBtn = button;
        self.pageView.dispalyPageIndex = button.tag-10;
    }
    
}
#pragma mark 分页视图
-(CLPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[CLPageView alloc] initWithFrame:CGRectMake(0,50, MainScreenW, MainScreenH-50)];
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
    return 3  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    if (pageIndex ==0)
    {
        RH_ApplyDiscountSiteSystemCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSiteSystemCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        return cell;
    }
    else if (pageIndex==1){
        RH_ApplyDiscountSiteMineCell* cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSiteMineCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        //                cell.delegate=self;
        return cell;
    }
    else if (pageIndex==2){
        RH_ApplyDiscountSiteSendCell* cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSiteSendCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        //                cell.delegate=self;
        return cell;
    }
    return nil;
    
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    
    UIButton *btn  = [self viewWithTag:pageIndex+10];
    [self selectedChooseBtn:btn];
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex
{
    //    [self _savePageLoadDatasContextAtPageIndex:pageIndex] ;
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
    RH_ApplyDiscountSiteSystemCell * cell = [self.pageView cellForPageAtIndex:0];
    RH_ApplyDiscountSiteMineCell *mineCell = [self.pageView cellForPageAtIndex:1];
    RH_ApplyDiscountSiteSendCell *sendCell = [self.pageView cellForPageAtIndex:2];
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
    else if (sendCell != nil) {
        CLPageLoadDatasContext * context = (id)[sendCell currentPageContext];
        NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
        if (context) {
            [self.dictPageCellDataContext setObject:context forKey:key] ;
        }else {
            [self.dictPageCellDataContext removeObjectForKey:key];
        }
    }
    
}
@end
