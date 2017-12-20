//
//  RH_SlideMenuViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/12/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_SlideMenuViewController.h"
#import "RH_SlideHeaderView.h"
#import "coreLib.h"

#define  SlideMenuWidth             floorf(MainScreenW * 0.75)

@interface RH_SlideMenuViewController ()<SlideHeaderViewProtocol,CLTableViewManagementDelegate>
@property (nonatomic,strong,readonly) RH_SlideHeaderView *slideHeaderView        ;
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_SlideMenuViewController
@synthesize slideHeaderView = _slideHeaderView          ;
@synthesize tableViewManagement = _tableViewManagement  ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenTabBar = YES ;
    self.hiddenNavigationBar = YES ;
    self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    [self setupUI] ;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return  120.0f ;
}

-(void)setupUI
{
    [self.topView addSubview:self.slideHeaderView] ;
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          self.topView.frameY+self.topView.frameHeigh,
                                                                          SlideMenuWidth,
                                                                          self.contentView.frameHeigh-self.topView.frameHeigh)
                                                         style:UITableViewStylePlain] ;
    
    self.contentTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|
                                             UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin ;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.contentTableView.backgroundColor = [UIColor clearColor] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

#pragma mark-
-(RH_SlideHeaderView *)slideHeaderView
{
    if (!_slideHeaderView){
        _slideHeaderView = [RH_SlideHeaderView createInstance] ;
        _slideHeaderView.delegate = self ;
        _slideHeaderView.frame = CGRectMake(0, 0, SlideMenuWidth, self.topView.frameHeigh);
        _slideHeaderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight ;
    }
    
    return _slideHeaderView ;
}

-(void)slideHeaderViewTouchUserCenter:(RH_SlideHeaderView*)slideHeaderView
{
    NSLog(@"") ;
}

#pragma mark-
#pragma mark-
-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_MainMenuCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    return _tableViewManagement ;
}

@end
