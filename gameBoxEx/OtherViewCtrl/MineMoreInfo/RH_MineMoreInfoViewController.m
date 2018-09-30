//
//  RH_MineMoreInfoViewController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//
//常见问题
#define QuestionsURL       @"/help/firstType.html"
//注册条款
#define RegisterProtocol   @"/getRegisterRules.html?path=terms"
//关于我们
#define AboutUs            @"/about.html?path=about"

#import "RH_MineMoreInfoViewController.h"
#import "RH_MineMoreDetailWebViewController.h"
/***原生***/
#import "RH_AboutUsViewController.h"
#import "RH_RegisterClauseViewController.h" //注册条款
#import "RH_HelpCenterViewController.h"
#import "coreLib.h"
#import "SDImageCache.h"
#import "RH_MineMoreClearStorageCell.h"
#import "IPsCacheManager.h"

@interface RH_MineMoreInfoViewController ()<CLTableViewManagementDelegate>
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
//缓存数据
@property(nonatomic,assign)CGFloat mbCache;
@end

@implementation RH_MineMoreInfoViewController
@synthesize tableViewManagement = _tableViewManagement   ;
- (BOOL)isSubViewController {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多" ;
    [self setupInfo];
}
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}
#pragma mark ==============计算缓存================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    //计算缓存
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    CGFloat fileSize=[self folderSizeAtPath:libPath];
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    float mbCache = bytesCache/1000/1000 + fileSize;
//    self.detailLabel.text = [NSString stringWithFormat:@"%.2fM",mbCache];
    self.mbCache = mbCache;
    
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_MineMoreCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    
    return _tableViewManagement ;
}
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    if (indexPath.item==4) {
        RH_MineMoreClearStorageCell *clearStorgeCell = ConvertToClassPointer(RH_MineMoreClearStorageCell, cell);
        [clearStorgeCell updateCellWithInfo:nil context:@(self.mbCache)];
       
    }
}
-(BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
         [self.navigationController pushViewController:[RH_HelpCenterViewController viewController] animated:YES] ;
        
    }else if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[RH_RegisterClauseViewController viewController] animated:YES] ;
    }else if (indexPath.row== 2)
    {
        [self.navigationController pushViewController:[RH_AboutUsViewController viewController] animated:YES] ;
    }
    else if (indexPath.row==4){
        [self showProgressIndicatorViewWithAnimated:YES title:@"清除缓存中"];
       //清除缓存文件
        [[IPsCacheManager sharedManager] clearCaches];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *p in files) {
            NSError *error;
            NSString *Path = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
                if (![Path containsString:@"Preferences"]) {
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                    //清除sdimage缓存图片
                    [[SDImageCache sharedImageCache]clearMemory];
                    //计算缓存
                    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
                    CGFloat fileSize=[self folderSizeAtPath:libPath];
                    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
                    float mbCache = bytesCache/1000/1000 + fileSize;
                    self.mbCache = mbCache;
                    [self.tableViewManagement reloadData];
                    [self.contentTableView reloadData];
                    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                        showMessage(self.view, @"缓存已清除", nil);
                    }];
                }
            }else{
                
            }
        }
    }
    return YES;
}
@end
