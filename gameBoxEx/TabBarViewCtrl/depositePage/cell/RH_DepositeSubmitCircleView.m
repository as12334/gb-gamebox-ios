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
@property (weak, nonatomic) IBOutlet UILabel *promoLab;

@property (weak, nonatomic) IBOutlet UILabel *chareLabel;
@property (nonatomic,strong)NSArray *salesArray;
@property (nonatomic,assign)NSInteger selectCellIndex;
@end
@implementation RH_DepositeSubmitCircleView

-(void)setupViewWithContext:(id)context
{
    RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, context);
//    self.moneyNumLabel.text = saleModel.mCounterFee;
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
    if ([THEMEV3 isEqualToString:@"green"]) {
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        self.depositeBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
    }else{
        self.depositeBtn.backgroundColor = colorWithRGB(11, 102, 75);
    }
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.showsVerticalScrollIndicator = NO;
    _tabelView.layer.cornerRadius = 5.f;
    _tabelView.layer.masksToBounds = YES;
    _tabelView.backgroundColor = colorWithRGB(242, 242, 242);
    [_tabelView registerNib:[UINib nibWithNibName:@"RH_DepositeSubmitCircleCell" bundle:nil] forCellReuseIdentifier:@"circleCell"];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.salesArray.count > 0) {
        self.tabelView.alpha = 1.0;
        self.promoLab.alpha = 1.0;
    }else{
        self.tabelView.alpha = 0.0;
        self.promoLab.alpha = 0.0;
    }
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
        cell.checkedImageview.image = [UIImage imageNamed:@"blue"];
    }
    else
    {
        cell.checkedImageview.image = [UIImage imageNamed:@"white"];
    }
    cell.backgroundColor = colorWithRGB(242, 242, 242);
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
