//
//  RH_CapitalQuickSelectView.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalQuickSelectView.h"
#import "coreLib.h"

@interface RH_CapitalQuickSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSArray *dataArr;
@end
@implementation RH_CapitalQuickSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.mainTabelView];
        _dataArr = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"最近七天",@"最近三十天"];
    }
    return self;
}

-(UITableView *)mainTabelView
{
    if (!_mainTabelView) {
        _mainTabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _mainTabelView.delegate = self;
        _mainTabelView.dataSource = self;
        _mainTabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _mainTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTabelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5) ;
        _mainTabelView.separatorColor = colorWithRGB(242, 242, 242) ;
    }
    return _mainTabelView;
}
#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
    
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
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = colorWithRGB(102, 102, 102) ;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.quickSelectBlock(indexPath.row);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
