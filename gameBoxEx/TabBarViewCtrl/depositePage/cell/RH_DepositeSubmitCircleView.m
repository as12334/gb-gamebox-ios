//
//  RH_DepositeSubmitCircleView.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeSubmitCircleView.h"
#import "RH_DepositeSubmitCircleCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositOriginseachSaleModel.h"
@interface RH_DepositeSubmitCircleView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet UIButton *depositeBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *chareLabel;
@property (nonatomic,strong)NSArray *salesArray;
@property (nonatomic,assign)NSInteger selectCellIndex;
@end
@implementation RH_DepositeSubmitCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setupViewWithContext:(id)context
{
    RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, context);
    self.moneyNumLabel.text = saleModel.mCounterFee;
    self.chareLabel.text = saleModel.mMsg;
    self.salesArray = saleModel.mDetailsModel;
}
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
    return self.salesArray.count;
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
    
    [cell updateCellWithInfo:nil context:self.salesArray[indexPath.item]];
    if (_selectCellIndex ==indexPath.item) {
        cell.checkedImageview.image = [UIImage imageNamed:@"choose"];
    }
    else
    {
        cell.checkedImageview.image = [UIImage imageNamed:@""];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectCellIndex = indexPath.item;
    ifRespondsSelector(self.delegate, @selector(depositeSubmitCircleViewChooseDiscount:)){
        
        [self.delegate depositeSubmitCircleViewChooseDiscount:((RH_DepositOriginseachSaleDetailsModel *)self.salesArray[indexPath.item]).mId];
    }
    [self.tabelView reloadData];
}
- (IBAction)transferMoneySelected:(id)sender {
    ifRespondsSelector(self.delegate, @selector(depositeSubmitCircleViewTransferMoney:)){
        [self.delegate depositeSubmitCircleViewTransferMoney:self];
    }
}
@end
