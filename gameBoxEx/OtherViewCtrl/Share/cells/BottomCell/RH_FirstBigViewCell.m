//
//  RH_FirstBigViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FirstBigViewCell.h"
#import "coreLib.h"
#import "RH_FirstBigCellHeadView.h"
#import "RH_ShareRecordCollectionPageCell.h"
#import "RH_RewardRuleTableViewCell.h"
#import "RH_SharePlayerRecommendModel.h"
@interface RH_FirstBigViewCell ()<firstBigCellHeadViewDelegate,CLPageViewDelegate,CLPageViewDatasource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong,readonly)RH_FirstBigCellHeadView *headView ;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ;
@property(nonatomic,strong)RH_SharePlayerRecommendModel *recommendModel;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation RH_FirstBigViewCell
@synthesize headView = _headView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark ==============获取数据================
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.recommendModel = ConvertToClassPointer(RH_SharePlayerRecommendModel, context);
    [self.tableView reloadData];
}
#pragma mark ==============创建UI================

-(void)createUI{
    [self.contentView addSubview:self.headView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.headView.frameHeigh+20,MainScreenW-40,300.f/375*screenSize().width-self.headView.frameHeigh-20) style:UITableViewStylePlain];
    self.tableView.delegate = self   ;
    self.tableView.dataSource = self ;
    self.tableView.sectionFooterHeight = 10.0f;
    self.tableView.sectionHeaderHeight = 10.0f ;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frameWidth, 0.1f)] ;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frameWidth, 0.1f)] ;
    self.tableView.layer.cornerRadius = 5.f;
    [self.contentView addSubview:self.tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        return 300;
    }
    return 300;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    RH_RewardRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RH_RewardRuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell updateCellWithInfo:nil context:self.recommendModel];
    cell.layer.cornerRadius = 5.f;
    cell.contentView.layer.cornerRadius= 5.f;
    return cell;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
  
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark --- 头视图
-(RH_FirstBigCellHeadView *)headView
{
    if (!_headView) {
        _headView = [[RH_FirstBigCellHeadView alloc]initWithFrame:CGRectMake(0, 10,MainScreenW, 50)];
        _headView.delegate= self;
    }
    return _headView;
}
#pragma mark --初始化字典
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
}

#pragma mark - firstBigCellHeadViewDelegate
-(void)firstBigCellHeadViewDidChangedSelectedIndex:(RH_FirstBigCellHeadView *)firstBigCellHeadView SelectedIndex:(NSInteger)selectedIndex
{
    self.pageView.dispalyPageIndex = selectedIndex ;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
