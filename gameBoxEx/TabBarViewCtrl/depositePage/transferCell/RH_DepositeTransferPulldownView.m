//
//  RH_DepositeTransferPulldownView.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/2.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferPulldownView.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeTransferPulldownView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)NSArray *array;

@end
@implementation RH_DepositeTransferPulldownView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
//        self.array = @[@"柜员机现金存款",@"柜员机转账",@"银行柜台存款"];
        
    }
    return self;
}
-(void)setupViewWithContext:(id)context
{
    self.array = ConvertToClassPointer(NSArray, context);
    [self addSubview:self.tabelView];
}
-(UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        _tabelView.separatorColor = colorWithRGB(242 , 242, 242) ;
        _tabelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5) ;
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
    return self.array.count;
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
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    cell.textLabel.textColor = colorWithRGB(153, 153, 153);
    RH_DepositeTansferCounterModel *counterModel = ConvertToClassPointer(RH_DepositeTansferCounterModel, self.array[indexPath.item]);
    cell.textLabel.text = counterModel.mName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(depositeTransferChooseCunterCelected:)){
        RH_DepositeTansferCounterModel *counterModel = ConvertToClassPointer(RH_DepositeTansferCounterModel, self.array[indexPath.item]);
        [self.delegate depositeTransferChooseCunterCelected:counterModel];
    }
    [self.tabelView reloadData];
}

@end
