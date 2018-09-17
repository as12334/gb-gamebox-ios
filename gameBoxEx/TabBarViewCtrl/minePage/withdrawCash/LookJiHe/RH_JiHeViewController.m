//
//  RH_JiHeViewController.m
//  gameBoxEx
//
//  Created by jun on 2018/8/24.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_JiHeViewController.h"
#import "RH_JiHeTableViewCell.h"
@interface RH_JiHeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation RH_JiHeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@{
                                @"createTime":@"存款时间",
                                @"rechargeAmount":@"存款金额",
                                @"rechargeAudit":@"存款稽核点",
                                @"rechargeFee":@"存款行政费用",
                                @"favorableAmount":@"优惠金额",
                                @"favorableAudit":@"优惠稽核点",
                                @"favorableFee":@"优惠扣除",
                                }];
    [self.serviceRequest startLookJiHe];
    [self configUI];
}
#pragma mark--
#pragma mark--lazy
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width*2,screenSize().height- NavigationBarHeight-STATUS_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        [_mainTableView registerNib:[UINib nibWithNibName:@"RH_JiHeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RH_JiHeTableViewCell"];
    }
    return _mainTableView;
}

-(void)configUI{
    UIScrollView *bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+STATUS_HEIGHT, screenSize().width, screenSize().height - NavigationBarHeight-STATUS_HEIGHT)];
    [self.view addSubview:bgScrollView];
    bgScrollView.contentSize = CGSizeMake(screenSize().width*2, screenSize().height - NavigationBarHeight-STATUS_HEIGHT);
    bgScrollView.bounces = NO;
    [bgScrollView addSubview:self.mainTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RH_JiHeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RH_JiHeTableViewCell"];
    [cell updateUIWithDictionary:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - serviceRequest
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeLookJiHe) {
        NSDictionary *dic = ConvertToClassPointer(NSDictionary, data);
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        NSString *message = [NSString stringWithFormat:@"%@",dic[@"message"]];
        if ([code isEqualToString:@"0"]) {
            if ([dic[@"data"][@"withdrawAudit"] isKindOfClass:[NSNull class]]) {
                 showMessage(self.view, @"暂无数据", nil);
            }else{
                NSArray *array  = dic[@"data"][@"withdrawAudit"];
                if (array.count > 0) {
                    [self.dataArray addObjectsFromArray:array];
                }else{
                    showMessage(self.view, @"暂无数据", nil);
                }
            }
          
            
        }else{
            showMessage(self.view, message, nil);
        }
        [self.mainTableView reloadData];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    showErrorMessage(self.view, error, nil);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
