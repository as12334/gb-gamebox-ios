//
//  RH_NewPromoViewControllerEx.m
//  gameBoxEx
//
//  Created by barca on 2018/9/29.
//  Copyright © 2018 luis. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "RH_NewPromoViewControllerEx.h"
#import "RH_SegmentViewController.h"
#import "RH_ExampleViewController.h"
#import "RH_DiscountActivityTypeModel.h"
static CGFloat const ButtonHeight = 50;
@interface RH_NewPromoViewControllerEx ()
@property(nonatomic,strong)RH_SegmentViewController *segmentVC;
@end
@implementation RH_NewPromoViewControllerEx
@synthesize segmentVC = _segmentVC;
-(BOOL)hasTopView
{
    return TRUE ;
}

-(CGFloat)topViewHeight
{
    return 0.0f ;
}
-(RH_SegmentViewController *)segmentVC
{
    if (!_segmentVC) {
       
    }
    return _segmentVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //数据请求
    [self tryRefreshData];
}
#pragma mark -进行数据请求
-(void)tryRefreshData
{
    //已存在数据情况 ，更新优惠标签 。
    [self showProgressIndicatorViewWithAnimated:YES title:@"信息更新中"] ;
    [self.serviceRequest startV3LoadDiscountActivityType];
}
#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        NSArray *originalDataAll = ConvertToClassPointer(NSArray, data);
        RH_SegmentViewController * segmentVC = [[RH_SegmentViewController alloc]init];
        segmentVC.titleArray = originalDataAll;
        NSMutableArray *controlArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < originalDataAll.count; i ++) {
            RH_ExampleViewController *vc = [[RH_ExampleViewController alloc]init];
            [controlArray addObject:vc];
        }
       
        segmentVC.titleSelectedColor = [UIColor redColor];
        segmentVC.subViewControllers = controlArray;
        segmentVC.buttonWidth = 80;
        segmentVC.buttonHeight = ButtonHeight;
        [segmentVC initSegment];
        [segmentVC addParentController:self];
        [self.contentLoadingIndicateView hiddenView];
        [segmentVC didSelectSegmentIndex:10000];
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
    }
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3PromoActivityType){
       [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
    }
}

@end
