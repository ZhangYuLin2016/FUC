//
//  POHSetViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHSetViewController.h"
#import "POHXiuGaiViewController.h"
#import "POHSetTableViewCell.h"
#import "POHLoginViewController.h"
#import "POHChangPayPasswordViewController.h"

@interface POHSetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dataDetailsSource;
@property (nonatomic, strong) NSArray *dataImagesSource;

@end

@implementation POHSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = txt(@"tip_user");
    [self getData];
    [self initMyView];
    [self logOutView];
    
}
- (void)logOutView{
    UIButton *logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, kScreenWidth - 40, 60)];
    [self.view addSubview:logOutBtn];
    [logOutBtn setTitle:txt(@"tip_logOut") forState:UIControlStateNormal];
    logOutBtn.backgroundColor = KBtnColor;
    logOutBtn.layer.masksToBounds =YES;
    logOutBtn.layer.cornerRadius =5;
    [logOutBtn addTarget:self action:@selector(louOutTap) forControlEvents:UIControlEventTouchUpInside];
}
- (void)louOutTap{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
    [self.navigationController presentViewController:[POHLoginViewController new] animated:kAnmotain completion:nil];
}
- (void)getData{
    _dataSource = @[
                    txt(@"tip_Modifytheloginpassword")
                    ,txt(@"tip_Modifyingthetransactionpassword")
                    ];
    _dataDetailsSource = @[
                           txt(@"tip_Loginpasswordmodification")
                           ,txt(@"tip_Transactionpasswordmodification")
                           ];
    _dataImagesSource = @[
                          @"zhanghu"
                          ,@"zhanghu"
                          ];
}
- (void)initMyView{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    
    self.tableView = tableView;
    [self.tableView registerClass:[POHSetTableViewCell class] forCellReuseIdentifier:@"MWPWoDeTableViewCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    POHSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWPWoDeTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.text = _dataSource[indexPath.row];
    cell.detailLable.text = _dataDetailsSource[indexPath.row];
    cell.image.image = kImageNamed(_dataImagesSource[indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[POHXiuGaiViewController new] animated:kAnmotain];

        }
            break;
            
        case 1:
        {
            [self.navigationController pushViewController:[POHChangPayPasswordViewController new] animated:kAnmotain];

        }
            break;
        default:
            break;
    }
   
}


@end
