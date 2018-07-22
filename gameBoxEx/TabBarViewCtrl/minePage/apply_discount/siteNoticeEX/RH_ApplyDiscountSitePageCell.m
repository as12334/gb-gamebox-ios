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
#import "RH_SiteMessageModel.h"
#import "RH_SiteMsgUnReadCountModel.h"

@interface RH_ApplyDiscountSitePageCell ()<CLPageViewDelegate,CLPageViewDatasource>
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong)UIButton *chooseBtn;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ;
@property(nonatomic,strong)NSMutableArray *btnArray;

@end

@implementation RH_ApplyDiscountSitePageCell
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context andSelectedIndex:(NSInteger)selectedIndex
{
    if (self.contentTableView == nil) {
        [self.pageView registerCellForPage:[RH_ApplyDiscountSiteSystemCell class] andReuseIdentifier:[RH_ApplyDiscountSiteSystemCell defaultReuseIdentifier]];
       [self.pageView registerCellForPage:[RH_ApplyDiscountSiteMineCell class] andReuseIdentifier:[RH_ApplyDiscountSiteMineCell defaultReuseIdentifier]];
        [self.pageView registerCellForPage:[RH_ApplyDiscountSiteSendCell class] andReuseIdentifier:[RH_ApplyDiscountSiteSendCell defaultReuseIdentifier]];
        self.backgroundColor = colorWithRGB(242, 242, 242);
        //分页视图
        [self.contentView addSubview:self.pageView];
//        self.pageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth ;
        self.pageView.whc_TopSpace(50).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0) ;
        //设置索引
        self.pageView.dispalyPageIndex = selectedIndex ;
        self.btnArray = [NSMutableArray array];
        //加上三个按钮
        NSArray *btnTitleArray = @[@"系统消息",@"我的消息",@"发送消息"];
        for (int i = 0; i<3; i++) {
            UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+80*i, 10, 70, 30);
            btn.backgroundColor = [UIColor lightGrayColor];
            [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = btn.bounds;
            maskLayer.path = maskPath.CGPath;
            btn.layer.mask = maskLayer;
            btn.tag  = i+10;
            [btn addTarget:self action:@selector(selectedChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:colorWithRGB(226, 226, 226)];
            [btn setTitleColor:colorWithRGB(51, 51, 51) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (i==selectedIndex) {
                if ([THEMEV3 isEqualToString:@"green"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
                }else if ([THEMEV3 isEqualToString:@"red"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
                }else if ([THEMEV3 isEqualToString:@"black"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
                }else if ([THEMEV3 isEqualToString:@"blue"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
                }else if ([THEMEV3 isEqualToString:@"orange"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
                }else if ([THEMEV3 isEqualToString:@"red_white"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
                }else if ([THEMEV3 isEqualToString:@"green_white"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
                }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
                }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
                }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
                }else{
                    btn.backgroundColor = RH_NavigationBar_BackgroundColor;
                }
                btn.selected = YES;
                self.chooseBtn = btn;
            }
            [_btnArray addObject:btn];
            [self addSubview:btn];
        }
        UILabel *sysBadgeLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 15, 15)];
        sysBadgeLab.backgroundColor = [UIColor redColor] ;
        
        sysBadgeLab.layer.cornerRadius = 7.5f;
        sysBadgeLab.layer.masksToBounds = YES;
        sysBadgeLab.textColor = [UIColor whiteColor] ;
        sysBadgeLab.font = [UIFont systemFontOfSize:7.f];
        sysBadgeLab.textAlignment = NSTextAlignmentCenter;
        sysBadgeLab.hidden = YES;
        [self addSubview:sysBadgeLab];
        _sysBadge =sysBadgeLab;
        [[NSNotificationCenter defaultCenter] addObserverForName:@"isHaveNoReadSiteSysMessage_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            RH_SiteMsgUnReadCountModel *model1 = note.object;
            if (model1.sysMsgUnreadCount &&[model1.sysMsgUnreadCount integerValue] > 0) {
                _sysBadge.hidden = NO ;
                if ([model1.sysMsgUnreadCount integerValue] > 99) {
                    _sysBadge.text = @"99+" ;
                    _sysBadge.font = [UIFont systemFontOfSize:7.f] ;
                }else
                {
                    _sysBadge.text = model1.sysMsgUnreadCount ;
                    _sysBadge.font = [UIFont systemFontOfSize:8.f] ;
                }
            }else
            {
                _sysBadge.hidden = YES ;
            }
        }];
        
        UILabel *mineBadgeLab = [[UILabel alloc] init];
        [mineBadgeLab setFrame:CGRectMake(10+80+60, 5, 15, 15)];
        mineBadgeLab.backgroundColor = [UIColor redColor] ;
        mineBadgeLab.layer.cornerRadius = 7.5;
        mineBadgeLab.layer.masksToBounds = YES;
        mineBadgeLab.textColor = [UIColor whiteColor] ;
        mineBadgeLab.font = [UIFont systemFontOfSize:8.f];
        mineBadgeLab.textAlignment = NSTextAlignmentCenter;
        mineBadgeLab.hidden = YES;
        [self addSubview:mineBadgeLab];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"isHaveNoReadSiteMineMessage_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            RH_SiteMsgUnReadCountModel *model1 = note.object;
            if (model1.mineMsgUnreadCount && [model1.mineMsgUnreadCount integerValue] > 0) {
                mineBadgeLab.hidden = NO ;
                if ([model1.mineMsgUnreadCount integerValue]> 99) {
                    mineBadgeLab.text  = @"99+";
                    mineBadgeLab.font = [UIFont systemFontOfSize:7.f];
                }else
                {
                     mineBadgeLab.text = model1.mineMsgUnreadCount ;
                     mineBadgeLab.font = [UIFont systemFontOfSize:8.f];
                }
            }else
            {
                mineBadgeLab.hidden = YES;
            }            
        }];

        
        CLBorderView *borderView = [[CLBorderView alloc]initWithFrame:CGRectMake(10,40, self.frameWidth-20, 1)];
        if ([THEMEV3 isEqualToString:@"green"]){
             borderView.backgroundColor  =  RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
             borderView.backgroundColor  = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
             borderView.backgroundColor  = RH_NavigationBar_BackgroundColor;
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            borderView.backgroundColor  = RH_NavigationBar_BackgroundColor_Blue;
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            borderView.backgroundColor  = RH_NavigationBar_BackgroundColor_Orange;
        }else if ([THEMEV3 isEqualToString:@"red_white"]){
            borderView.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
        }else if ([THEMEV3 isEqualToString:@"green_white"]){
            borderView.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
        }else if ([THEMEV3 isEqualToString:@"orange_white"]){
            borderView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
            borderView.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            borderView.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
        }else{
             borderView.backgroundColor  =  RH_NavigationBar_BackgroundColor;
        }
       
        [self addSubview:borderView];
    }else {
        [self updateWithContext:context];
    }
}

#pragma mark 选择按钮的点击事件
-(void)selectedChooseBtn:(UIButton *)button
{
    [self.siteSendCell.listView removeFromSuperview];
    if (!button.isSelected) {
        self.chooseBtn.selected = !self.chooseBtn.selected;
        self.chooseBtn.backgroundColor = colorWithRGB(226, 226, 226);
        button.selected = !button.selected;
        if ([THEMEV3 isEqualToString:@"green"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        }else if ([THEMEV3 isEqualToString:@"red_white"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
        }else if ([THEMEV3 isEqualToString:@"green_white"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
        }else if ([THEMEV3 isEqualToString:@"orange_white"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            button.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
        }else{
            button.backgroundColor = RH_NavigationBar_BackgroundColor;
        }
        self.chooseBtn = button;
        self.pageView.dispalyPageIndex = button.tag-10;
    }
}
#pragma mark 分页视图
-(CLPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[CLPageView alloc] initWithFrame:CGRectMake(0,50, MainScreenW, MainScreenH-110-NavigationBarHeight-StatusBarHeight)];
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
        return cell;
    }
    else if (pageIndex==2){
        RH_ApplyDiscountSiteSendCell* cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSiteSendCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:nil Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex] ] ;
        self.siteSendCell = cell;
        return cell;
    }
    return nil;
    
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    for (UIButton *btn in self.btnArray) {
        btn.selected = NO;
        btn.backgroundColor =colorWithRGB(200, 200, 200);
        
    }
    ((UIButton *)self.btnArray[pageIndex]).selected = YES;
    self.chooseBtn =((UIButton *)self.btnArray[pageIndex]);
    ((UIButton *)self.btnArray[pageIndex]).backgroundColor =colorWithRGB(23, 102, 187);
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

#pragma mark -
-(void)paste:(id)sender
{
    //解决 在粘贴为空时，系统转发出的的消息 
}

-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isHaveNoReadSiteSysMessage_NT" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isHaveNoReadSiteMineMessage_NT" object:nil];
}

@end
