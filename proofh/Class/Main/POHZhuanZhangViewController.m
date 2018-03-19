//
//  POHZhuanZhangViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/8.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHZhuanZhangViewController.h"
#import "POHScanViewController.h"

@interface POHZhuanZhangViewController ()
@property (nonatomic, strong) UITextField *addrTF;
@property (nonatomic, strong) UITextField *numTF;
@property (nonatomic, strong) UITextField *addPasswordTF;

@end

@implementation POHZhuanZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = txt(@"tip_Exchangeofmoney");
    [self myView];
}

- (void)scanTap{
    POHScanViewController *vc = [POHScanViewController new];
    vc.comeFromVC = ScanSuccessJumpComeFromZhuanZhang;
    vc.returnValueBlock = ^(NSString *strValue) {
        if ([strValue rangeOfString:@":"].location != NSNotFound) {
            NSArray *array = [strValue componentsSeparatedByString:@":"];
            NSString *str = [NSString stringWithFormat:@"%@",array[1]];
            _addrTF.text = str;
        }else{
            _addrTF.text = strValue;
        }
        
    };
    [self.navigationController pushViewController:vc animated:kAnmotain];
}
- (void)myView{
    UIView *addrView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 41)];
    [self.view addSubview:addrView];
    
    _addrTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40-40, 40)];
    [addrView addSubview:_addrTF];
    _addrTF.placeholder = txt(@"tip_address");

    if (_myAddr.length > 0) {
        //截取字符串
        if ([_myAddr rangeOfString:@":"].location != NSNotFound) {
            //条件为真，表示字符串searchStr包含一个自字符串substr
            NSArray *array = [_myAddr componentsSeparatedByString:@":"];
            NSString *str = [NSString stringWithFormat:@"%@",array[1]];
            _addrTF.text = str;
        }else{
            //条件为假，表示不包含要检查的字符串
            _addrTF.text = _myAddr;

        }
    }else{
        _addrTF.text = @"";
    }
    
    UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addrTF.frame), 0, 40, 40)];
    [addrView addSubview:scanBtn];
    [scanBtn setImage:kImageNamed(scanGrayIcon) forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanTap) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth - 40, 1)];
    [addrView addSubview:lineView];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(addrView.frame)+5, kScreenWidth-40, 20)];
    [self.view addSubview:label];
    label.text = txt(@"tip");
    label.numberOfLines = 0;
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:15];
    
    
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+10, kScreenWidth-40, 40)];
    [self.view addSubview:numView];
    numView.layer.masksToBounds = YES;
    numView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    numView.layer.borderWidth = 2;
    
    _numTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, numView.bounds.size.width-20-60, 40)];
    [numView addSubview:_numTF];
    _numTF.placeholder =@"0.0000";
    UIView *hLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numTF.frame), 5, 1, 30)];
    [numView addSubview:hLineView];
    hLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hLineView.frame), 0, numView.bounds.size.width - CGRectGetMaxX(hLineView.frame), 40)];
    [numView addSubview:tipLabel];
    tipLabel.text = @"FUC";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *yuELabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(numView.frame)+5, kScreenWidth - 40, 20)];
    [self.view addSubview:yuELabel];
    NSString *str = [NSString stringWithFormat:@"可用余额  %@ FUC", _myYuE];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName value:KBtnColor range:NSMakeRange(6, _myYuE.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(6, _myYuE.length)];
    yuELabel.attributedText = att;

//=========

    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(yuELabel.frame) + 20, kScreenWidth - 40, 40)];
    passView.layer.masksToBounds = YES;
    passView.layer.borderWidth = 2;
    passView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.view addSubview:passView];

    _addPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, passView.bounds.size.width - 20, 40)];
    [passView addSubview:_addPasswordTF];
    _addPasswordTF.secureTextEntry = YES;
    _addPasswordTF.placeholder = [NSString stringWithFormat:@"%@",txt(@"tip_ppass")];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passView.frame)+50, kScreenWidth - 40, 40)];
    [self.view addSubview:btn];
    btn.backgroundColor = KBtnColor;
    [btn setTitle:txt(@"tip_sure") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(zhuanZhangTap) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 请求接口，转账
- (void)zhuanZhangTap{
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].zhuanZhang parameter:@{@"num":_numTF.text, @"paypassword":_addPasswordTF.text, @"reuser":_addrTF.text, @"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *responseObjectDic = responseObject;
        if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }else{
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }
        _addrTF.text = @"";
        _numTF.text = @"";
        _addPasswordTF.text = @"";
    } failure:nil];
}

@end
