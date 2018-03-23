//
//  RH_DepositeSubmitCircleView.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeSubmitCircleView.h"
#import "RH_DepositeSubmitCircleCell.h"
@interface RH_DepositeSubmitCircleView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet UIButton *depositeBtn;
@end
@implementation RH_DepositeSubmitCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
     [self setupUI];
}
-(void)setupUI{
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.depositeBtn.layer.cornerRadius = 5.f;
    self.depositeBtn.layer.masksToBounds = YES;
    
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.showsVerticalScrollIndicator = NO;
    _tabelView.layer.cornerRadius = 5.f;
    _tabelView.layer.masksToBounds = YES;
    _tabelView.backgroundColor = [UIColor lightGrayColor];
    [_tabelView registerNib:[UINib nibWithNibName:@"RH_DepositeSubmitCircleCell" bundle:nil] forCellReuseIdentifier:@"circleCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeSubmitCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleCell"];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RH_DepositeSubmitCircleCell" owner:self options:nil]lastObject];
    }
    return cell;
}
@end
