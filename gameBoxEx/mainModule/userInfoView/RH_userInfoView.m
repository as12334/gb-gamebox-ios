//
//  RH_userInfoView.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_userInfoView.h"
#import "RH_UserInfoTotalCell.h"
#import "RH_UserInfoGengeralCell.h"

@interface RH_userInfoView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) IBOutlet UITableView *tableView ;
@property(nonatomic,strong) IBOutlet UIButton *btnRetrive   ;
@property(nonatomic,strong) IBOutlet UIButton *btnSave      ;

@end

@implementation RH_userInfoView
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.borderMask = CLBorderMarkAll ;
    self.borderColor = colorWithRGB(204, 204, 204) ;
    self.borderWidth = PixelToPoint(1.0f) ;
    self.layer.masksToBounds = YES ;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    self.btnRetrive.backgroundColor = colorWithRGB(27, 117, 217) ;
    self.btnRetrive.layer.cornerRadius = 5.0f ;
    [self.btnRetrive setTitleColor:colorWithRGB(239, 239, 239) forState:UIControlStateNormal] ;
    [self.btnRetrive.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
    
    self.btnSave.backgroundColor = colorWithRGB(14, 195, 146) ;
    self.btnSave.layer.cornerRadius = 5.0f ;
    [self.btnSave setTitleColor:colorWithRGB(239, 239, 239) forState:UIControlStateNormal] ;
    [self.btnSave.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
}


#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}


@end
