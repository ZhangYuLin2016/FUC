//
//  POHMainViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHMainViewController.h"
#import "POHErWeiMaViewController.h"
#import "POHSetViewController.h"
#import "POHMainTableViewCell.h"
#import "POHZhuanZhangViewController.h"
#import "POHScanViewController.h"

@interface POHMainViewController ()<UITableViewDelegate, UITableViewDataSource>{
    MBProgressHUD *hud;
    UILabel *label;
}
@property(strong, nonatomic) NSMutableArray *zrdatas;//转入
@property(strong, nonatomic) NSMutableArray *alldatas;//转出
@end

@implementation POHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.zrdatas = [NSMutableArray array];
    self.alldatas = [NSMutableArray array];
    
    [self bottomView];
    [self topView];
    [self mytableView];
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self navItem];
}

- (void)topView{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    bgView.image = kImageNamed(homeBgIcon);
    [self.view addSubview:bgView];
    
    
    UILabel *moneylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180/2-50, kScreenWidth, 50)];
    [bgView addSubview:moneylabel];
    moneylabel.text = txt(@"tip_zongZiChan");
    moneylabel.textColor = KWhiteColor;
    moneylabel.textAlignment = NSTextAlignmentCenter;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200/2, kScreenWidth, 40)];
    [bgView addSubview:label];
    label.textColor = KWhiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text =@"0.0000";
    label.font = [UIFont systemFontOfSize:40];
    
    
}

- (void)mytableView{
    UITableView * tableView = [[UITableView alloc] init];
    if (Is_Iphone_X) {
        tableView.frame = CGRectMake(0, 200, kScreenWidth, kScreenHeight - 200 - 50 - 120);
    }else{
        tableView.frame = CGRectMake(0, 200, kScreenWidth, kScreenHeight - 200 - 50 - 64);
    }
    
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[POHMainTableViewCell class] forCellReuseIdentifier:@"POHMainTableViewCell"];
    self.tableView = tableView;
    [self loadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadData];
    }];
}

- (void)loadData{
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].yuEURL parameter:@{@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        [hud hide:YES];
        NSDictionary *da = [responseObject objectForKey:@"data"];
        [self.zrdatas removeAllObjects];
        @try {

            NSMutableArray *originalArray = [da objectForKey:@"trans"];
            NSString *str = [NSString stringWithFormat:@"%@",originalArray];
            if (str.length > 0){
                self.zrdatas = [NSMutableArray arrayWithArray: [[originalArray reverseObjectEnumerator] allObjects]];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"error");
        } @finally {
        }
        [self.tableView reloadData];
        
        @try {
            NSNumber *balance = [da objectForKey:@"balance"];
            double balance_doub = [balance doubleValue];
            label.text =[NSString stringWithFormat:@"%.4f", balance_doub];
        } @catch (NSException *exception) {
            NSLog(@"exception");
        } @finally {
            
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [hud hide:YES];
        [self.tableView.mj_header endRefreshing];
        [self showTost:txt(@"tip_neterror")];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = KWhiteColor;
    
    UIView *hLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 6, 34)];
    [headerView addSubview:hLineView];
    hLineView.backgroundColor = KBtnColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(20, 0, 100, 50);
    [headerView addSubview:label];
    label.text = @"交易记录";

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:lineView];
    
    return headerView;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zrdatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    POHMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POHMainTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *item = [self.zrdatas objectAtIndex:indexPath.row];
    NSNumber *amount = [item objectForKey:@"amount"];
    double doub = [amount doubleValue];
    double abs = fabs(doub);
    cell.timeLabel.text = [NSString stringWithFormat:@"%@：    %@", txt(@"tip_time"),[self timeWithTimeIntervalString:[item objectForKey:@"time"]]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"数量：    %.4f", abs];
    cell.addrLabel.text = [NSString stringWithFormat:@"地址：    %@",[item objectForKey:@"address"]];
    
    NSString *category = [item objectForKey:@"category"];
    if ([@"send" isEqualToString:category]) {
        cell.zhuangTaiLabel.text  = [NSString stringWithFormat:@"状态：    %@", txt(@"tip_zhuanChu")];
    } else if ([@"receive" isEqualToString:category]) {
        cell.zhuangTaiLabel.text  = [NSString stringWithFormat:@"状态：    %@", txt(@"tip_zhuanRu")];
    }
    return cell;
}

#pragma mark - views
#pragma mark - bottomView
- (void)bottomView{
    UIView *bottomView = [[UIView alloc] init];
    if (Is_Iphone_X) {
        bottomView.frame = CGRectMake(0, kScreenHeight-50-120, kScreenWidth, 50);
    }else{
        bottomView.frame = CGRectMake(0, kScreenHeight-50-64, kScreenWidth, 50);
    }
    
    [self.view addSubview:bottomView];
    UIButton *shouKuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 50)];
    [bottomView addSubview:shouKuanBtn];
    [shouKuanBtn setTitle:txt(@"tip_shouKuan") forState:UIControlStateNormal];
    [shouKuanBtn setTitleColor:KBtnColor forState:UIControlStateNormal];
    shouKuanBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [shouKuanBtn addTarget:self action:@selector(shouKuan) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zhuanzhangBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 50)];
    [bottomView addSubview:zhuanzhangBtn];
    zhuanzhangBtn.backgroundColor = KBtnColor;
    [zhuanzhangBtn setTitle:txt(@"tip_zhuanZhang") forState:UIControlStateNormal];
    [zhuanzhangBtn addTarget:self action:@selector(zhuanZhan) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - nav
- (void)navItem{
    [self.navigationController.navigationBar setBackgroundImage:kImageNamed(homeBgIcon) forBarMetrics:UIBarMetricsDefault];    
    [self navLeftItem];
    [self navRightItem];
}

- (void)navLeftItem{
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:myusername style:UIBarButtonItemStyleDone target:nil action:nil];
    [releaseButon setTintColor:KWhiteColor];
    self.navigationItem.leftBarButtonItem = releaseButon;
}

- (void)navRightItem{
    NSArray *iconArr = @[setIcon, scanIcon];
    //设置
    UIBarButtonItem *setBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:iconArr[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(sheZhi)];
    //扫描
    UIBarButtonItem *codeBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:iconArr[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(saoMiao)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:codeBtn, setBtn, nil]];
    
}
- (void)saoMiao{
//    POHScanViewController *vc = [POHScanViewController new];
//    vc.comeFromVC = ScanSuccessJumpComeFromZhuanZhang;
//    vc.returnValueBlock = ^(NSString *strValue) {
//        POHZhuanZhangViewController *vc = [POHZhuanZhangViewController new];
//        vc.myAddr = strValue;
//        vc.myYuE = label.text;
//        [self.navigationController pushViewController:vc animated:kAnmotain];
//    };
//    [self.navigationController pushViewController:vc animated:kAnmotain];
    
    POHScanViewController *scanVC = [[POHScanViewController alloc] initWithCanmOnFinish:^(NSString *result, NSError *error) {
        if (error) {
            [self showTost:@"error"];
        }else{
            POHZhuanZhangViewController *vc = [POHZhuanZhangViewController new];
            vc.myAddr = result;
            vc.myYuE = label.text;
            [self.navigationController pushViewController:vc animated:kAnmotain];
        }
    }];
    [self.navigationController pushViewController:scanVC animated:kAnmotain];
}

#pragma mark - private Methed
- (void)sheZhi{
    [self.navigationController pushViewController:[POHSetViewController new] animated:kAnmotain];
}
- (void)shouKuan{
    [self.navigationController pushViewController:[POHErWeiMaViewController new] animated:kAnmotain];
}

- (void)zhuanZhan{
    POHZhuanZhangViewController *zhuanZhangVC = [POHZhuanZhangViewController new];
    zhuanZhangVC.myYuE = label.text;
    [self.navigationController pushViewController:zhuanZhangVC animated:kAnmotain];
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
