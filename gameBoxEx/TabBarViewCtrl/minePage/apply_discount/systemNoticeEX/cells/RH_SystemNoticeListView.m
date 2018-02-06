//
//  RH_SystemNoticeListView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SystemNoticeListView.h"
#import "coreLib.h"
@interface RH_SystemNoticeListView()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation RH_SystemNoticeListView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tabelView];
    }
    return self;
}
-(UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tabelView.separatorColor = colorWithRGB(242, 242, 242);
        _tabelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return _tabelView;
}
#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return 7;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray *array = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"最近7天",@"最近30天"];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    cell.textLabel.textColor = colorWithRGB(153, 153, 153);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.kuaixuanBlock(indexPath.row);
}

@end
