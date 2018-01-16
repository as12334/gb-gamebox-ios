//
//  RH_WithdrawCashController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawCashController.h"
#import "coreLib.h"
#import "PXAlertView+Customization.h"
#import "RH_WithdrawAddBitCoinAddressController.h"
@interface RH_WithdrawCashController ()<CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong, readonly) UIView  *footerView;
@property (nonatomic, strong) UIButton *button_Submit;
@property (nonatomic, strong) UIButton *button_Check;
@end

@implementation RH_WithdrawCashController
{
    UISegmentedControl *mainSegmentControl;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"取款";
    [self setupInfo];
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_WithdrawCash" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (UIView *)footerView {
    
    if (_footerView == nil) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, screenSize().width, 150);
        
        self.button_Submit = [UIButton new];
        [_footerView addSubview:self.button_Submit];
        self.button_Submit.whc_LeftSpace(20).whc_RightSpace(20).whc_TopSpace(50).whc_Height(44);
        self.button_Submit.layer.cornerRadius = 5;
        self.button_Submit.clipsToBounds = YES;
        [self.button_Submit setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.button_Submit addTarget:self action:@selector(buttonConfirmHandle) forControlEvents:UIControlEventTouchUpInside];
        self.button_Submit.backgroundColor = colorWithRGB(27, 117, 217);
        self.button_Check = [UIButton new];
        [_footerView addSubview:self.button_Check];
        self.button_Check.whc_TopSpace(10).whc_RightSpace(5).whc_Height(20).whc_Width(150);
        [self.button_Check setTitle:@"查看稽核" forState:UIControlStateNormal];
        [self.button_Check addTarget:self action:@selector(buttonCheckHandle) forControlEvents:UIControlEventTouchUpInside];
        [self.button_Check setTitleColor:colorWithRGB(27, 117, 217) forState:UIControlStateNormal];
        self.button_Check.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.button_Check.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _footerView;
}

- (void)buttonCheckHandle {
    
}

- (void)buttonConfirmHandle {
    
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    self.contentTableView.tableFooterView = [self footerView];
    
    mainSegmentControl = [[UISegmentedControl alloc] init];
    [self.contentView addSubview:mainSegmentControl];
    mainSegmentControl.whc_TopSpace(74).whc_CenterX(0).whc_Width(180).whc_Height(35);
    mainSegmentControl.tintColor = colorWithRGB(27, 117, 217);
    [mainSegmentControl insertSegmentWithTitle:@"银行卡账户" atIndex:0 animated:YES];
    [mainSegmentControl insertSegmentWithTitle:@"比特币账户" atIndex:1 animated:YES];
    mainSegmentControl.selectedSegmentIndex = 0;
    [mainSegmentControl addTarget:self action:@selector(segmentControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.contentTableView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_TopSpace(130);
}
- (void)segmentControlValueDidChange:(UISegmentedControl *)segmentControl {
    if (segmentControl.selectedSegmentIndex == 0) {
        
        [self.tableViewManagement reloadDataWithPlistName:@"RH_WithdrawCash"];
    }
    if (segmentControl.selectedSegmentIndex == 1) {
        
        [self.tableViewManagement reloadDataWithPlistName:@"RH_WithdrawCashBitCoin"];
        PXAlertView *alert = [PXAlertView showAlertWithTitle:@"提示" message:@"没有绑定比特币地址" cancelTitle:@"取消" otherTitles:@[@"立即添加"] completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (cancelled) {
                //
            }else {
                // tianjia
                RH_WithdrawAddBitCoinAddressController *vc = [[RH_WithdrawAddBitCoinAddressController alloc] init];
                [self showViewController:vc sender:nil];
            }
        }];
        [alert setBackgroundColor:colorWithRGB(234, 234, 234)];
        [alert setTitleColor:colorWithRGB(153, 153, 153)];
        [alert setMessageColor:colorWithRGB(153, 153, 153)];
        [alert setOtherButtonBackgroundColor:colorWithRGB(27, 117, 217)];
    }
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    if (mainSegmentControl.selectedSegmentIndex == 0) {
        //
    }
    if (mainSegmentControl.selectedSegmentIndex == 1) {
        //
        if (indexPath.section == 0) {
            PXAlertView *alert = [PXAlertView showAlertWithTitle:@"提示" message:@"没有绑定比特币地址" cancelTitle:@"取消" otherTitles:@[@"立即添加"] completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (cancelled) {
                    //
                }else {
                    // tianjia
                    RH_WithdrawAddBitCoinAddressController *vc = [[RH_WithdrawAddBitCoinAddressController alloc] init];
                    [self showViewController:vc sender:nil];
                }
            }];
            [alert setBackgroundColor:colorWithRGB(234, 234, 234)];
            [alert setTitleColor:colorWithRGB(153, 153, 153)];
            [alert setMessageColor:colorWithRGB(153, 153, 153)];
            [alert setOtherButtonBackgroundColor:colorWithRGB(27, 117, 217)];
        }
    }
    return YES;
}
@end
