//
//  POHLoginViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHLoginViewController.h"
#import "POHMainViewController.h"
#import "AppDelegate.h"
#import "POHNavViewController.h"
#import "POHForgetPassViewController.h"

@interface POHLoginViewController ()<UIApplicationDelegate,UITextFieldDelegate>{
    
    NSInteger selectTag;
    NSArray   * titleArr;
    UIView    * sectionView;
    
    UIView    * loginView;
    UIView    * registerView;
    UIView    * registerNextView;

    int timeDown;
    NSTimer *timer;
    UIButton *sendVcodeBtn;

}
@property (nonatomic,strong) UIImageView *bgViewImage;

/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;

//  注册
@property (nonatomic, strong) UITextField *iphoneNumTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *vCodeTF;
@property (nonatomic, strong) UITextField *paypasswordTF;
@property (nonatomic, strong) UITextField *repaypasswordTF;


//登陆
@property (nonatomic, strong) UITextField *iphoneNumTF_login;
@property (nonatomic, strong) UITextField *passwordTF_login;

@end

@implementation POHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectTag=0;
    titleArr=@[@"登陆",@"注册"];
    [self reNextPage];
    [self loginView];
    [self myRegisterView];
    [self myloginView];
}
- (void)loginView{
    _bgViewImage  = [[UIImageView alloc] initWithFrame:kScreenRect];
    [self.view addSubview:_bgViewImage];
    _bgViewImage.image = kImageNamed(bgviewIcon);
    _bgViewImage.userInteractionEnabled = YES;
    
    // logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, (150-60+64)/2, 60, 60)];
    [_bgViewImage addSubview:logoImageView];
    logoImageView.contentMode =  UIViewContentModeCenter;
    logoImageView.image = kImageNamed(logoViewIcon) ;
    
    sectionView=[[UIView alloc] initWithFrame:CGRectMake(20, 150+64, kScreenWidth-40, 40)];
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5 , 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = sectionView.bounds;
    maskLayer.path = fieldPath.CGPath;
    sectionView.layer.mask = maskLayer;

    
    sectionView.backgroundColor=KWhiteColor;
    [_bgViewImage addSubview:sectionView];
    
    for (int i=0; i<2; i++) {
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(i*kScreenWidth/2, 0, kScreenWidth/2, 40)];
        [btn setTitle:titleArr[i] forState:0];
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kTextColor forState:0];
        [btn setTitleColor:KBtnColor forState:UIControlStateSelected];
        [sectionView addSubview:btn];
        if (i==0) {
            btn.selected=YES;
            self.selectedBtn=btn;
        }else{
            btn.selected=NO;
        }
    }
}

-(void)selectBtn:(UIButton*)sender{
    selectTag=sender.tag;
    if (sender!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
    if (selectTag == 1000) {
        [self.view sendSubviewToBack:registerNextView];
        [self.view sendSubviewToBack:registerView];
        [self.view bringSubviewToFront:loginView];
    }else{
        [self.view sendSubviewToBack:registerNextView];
        [self.view sendSubviewToBack:loginView];
        [self.view bringSubviewToFront:registerView];
    }
}

- (void)myloginView{
    loginView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sectionView.frame), kScreenWidth - 40, 220)];
    [_bgViewImage addSubview:loginView];
    loginView.backgroundColor = KWhiteColor;
    
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:loginView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5 , 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = loginView.bounds;
    maskLayer.path = fieldPath.CGPath;
    loginView.layer.mask = maskLayer;
    
    UIView *iphoneNumView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, loginView.bounds.size.width-40, 40)];
    [loginView addSubview:iphoneNumView];
    iphoneNumView.layer.masksToBounds = YES;
    iphoneNumView.layer.borderWidth = 1;
    iphoneNumView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    iphoneNumView.layer.cornerRadius = 3;
    
    UIImageView *iphoneIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [iphoneNumView addSubview:iphoneIconView];
    iphoneIconView.image = kImageNamed(iphoneNumIcon);
    
    _iphoneNumTF_login = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, iphoneNumView.bounds.size.width-40, 40)];
    [iphoneNumView addSubview:_iphoneNumTF_login];
    _iphoneNumTF_login.placeholder = txt(@"input_iphoneNum");
    _iphoneNumTF_login.keyboardType = UIKeyboardTypeNumberPad;
    _iphoneNumTF_login.delegate = self;
    
    //输入密码
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iphoneNumView.frame)+20, loginView.bounds.size.width-40, 40)];
    [loginView addSubview:passView];
    passView.layer.masksToBounds = YES;
    passView.layer.borderWidth = 1;
    passView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    passView.layer.cornerRadius = 3;
    
    UIImageView *passIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [passView addSubview:passIconView];
    passIconView.image = kImageNamed(passIcon);
    
    _passwordTF_login = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, passView.bounds.size.width-40, 40)];
    [passView addSubview:_passwordTF_login];
    _passwordTF_login.placeholder = txt(@"tip_Pass");
    _passwordTF_login.delegate = self;
    _passwordTF_login.secureTextEntry = YES;
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passView.frame)+20, loginView.bounds.size.width-40-100, 40)];
    [loginView addSubview:forgetBtn];
    forgetBtn.layer.masksToBounds = YES;
    forgetBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    forgetBtn.layer.borderWidth = 1;
    [forgetBtn setTitle:@"是否忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:KBtnColor forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetPass) forControlEvents:UIControlEventTouchUpInside];

    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(forgetBtn.frame), CGRectGetMaxY(passView.frame)+20, 100, 40)];
    [loginView addSubview:loginBtn];
    loginBtn.backgroundColor = KBtnColor;
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginTap) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 请求接口，登陆
- (void)loginTap{
    [self toLogin];
}

- (void)toLogin{
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].loginURL parameter:@{@"username":_iphoneNumTF_login.text,@"password":_passwordTF_login.text,@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *responseObjectDic = responseObject;
        NSLog(@"responseObjectDic=%@", responseObjectDic);
        if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
            //成功之后，保存手机号到本地【修改账号密码的时候取出来】
            NSDictionary *dd = [responseObjectDic objectForKey:@"data"];

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_iphoneNumTF_login.text forKey:@"username"];
            
            [userDefaults setObject:dd[@"token"] forKey:@"token"];
            [userDefaults setObject:dd[@"addr"] forKey:@"addr"];

            [self presentViewController:[[POHNavViewController alloc] initWithRootViewController:[POHMainViewController new]] animated:kAnmotain completion:nil];
            
        }else{
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }
        
    } failure:nil];
}
- (void)forgetPass{
    
     [self presentViewController:[POHForgetPassViewController new] animated:kAnmotain completion:nil];
    
}
- (void)myRegisterView{
    registerView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sectionView.frame), kScreenWidth - 40, 300)];
    [self.view addSubview:registerView];
    registerView.backgroundColor = KWhiteColor;
    
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:registerView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5 , 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = registerView.bounds;
    maskLayer.path = fieldPath.CGPath;
    registerView.layer.mask = maskLayer;
    
    
    
    // 手机号码
    UIView *iphoneNumView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, registerView.bounds.size.width-40, 40)];
    [registerView addSubview:iphoneNumView];
    iphoneNumView.layer.masksToBounds = YES;
    iphoneNumView.layer.borderWidth = 1;
    iphoneNumView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    iphoneNumView.layer.cornerRadius = 3;
    
    UIImageView *iphoneIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [iphoneNumView addSubview:iphoneIconView];
    iphoneIconView.image = kImageNamed(iphoneNumIcon);
    
    _iphoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, iphoneNumView.bounds.size.width-40-60, 40)];
    [iphoneNumView addSubview:_iphoneNumTF];
    _iphoneNumTF.placeholder = txt(@"input_iphoneNum");
    _iphoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    sendVcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iphoneNumTF.frame), 5, 30, 30)];
    [iphoneNumView addSubview:sendVcodeBtn];
    [sendVcodeBtn setImage:kImageNamed(sendVCodeIcon) forState:UIControlStateNormal];
    [sendVcodeBtn addTarget:self action:@selector(sendVCodeTap) forControlEvents:UIControlEventTouchUpInside];
    
    //验证码
    UIView *vCodeView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iphoneNumView.frame)+20, registerView.bounds.size.width-40, 40)];
    [registerView addSubview:vCodeView];
    vCodeView.layer.masksToBounds = YES;
    vCodeView.layer.borderWidth = 1;
    vCodeView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    vCodeView.layer.cornerRadius = 3;
    
    UIImageView *vCodeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [vCodeView addSubview:vCodeIconView];
    vCodeIconView.image = kImageNamed(vCodeIcon);
    
    _vCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, vCodeView.bounds.size.width-40, 40)];
    [vCodeView addSubview:_vCodeTF];
    _vCodeTF.placeholder = txt(@"input_vcode");
    _vCodeTF.keyboardType = UIKeyboardTypeNumberPad;

    
    //输入新密码
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(vCodeView.frame)+20, registerView.bounds.size.width-40, 40)];
    [registerView addSubview:passView];
    passView.layer.masksToBounds = YES;
    passView.layer.borderWidth = 1;
    passView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    passView.layer.cornerRadius = 3;
    
    UIImageView *passIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [passView addSubview:passIconView];
    passIconView.image = kImageNamed(passIcon);
    
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, passView.bounds.size.width-40, 40)];
    [passView addSubview:_passwordTF];
    _passwordTF.placeholder = txt(@"tip_newPass");
    _passwordTF.secureTextEntry = YES;
    UIView *registerBtnView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passView.frame)+50, registerView.bounds.size.width-120, 40)];
    [registerView addSubview:registerBtnView];
    CGFloat bw = registerBtnView.bounds.size.width;
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake((bw-120)/4-15, 0, 30, 30)];
    [registerBtnView addSubview:btn1];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    btn1.backgroundColor = KBtnColor;
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 15;
    
    UIButton *btni0 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, 10, 10, 10)];
    btni0.backgroundColor = KBtnNoneColor;
    btni0.layer.masksToBounds = YES;
    btni0.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni0];
    
    UIButton *btni1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni0.frame)+10, 10, 10, 10)];
    btni1.backgroundColor = KBtnNoneColor;
    btni1.layer.masksToBounds = YES;
    btni1.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni1];
    
    UIButton *btni2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni1.frame)+10, 10, 10, 10)];
    btni2.backgroundColor = KBtnNoneColor;
    btni2.layer.masksToBounds = YES;
    btni2.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni2];
    
    UIButton *btni3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni2.frame)+10, 10, 10, 10)];
    btni3.backgroundColor = KBtnNoneColor;
    btni3.layer.masksToBounds = YES;
    btni3.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni3];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni3.frame)+10, 0, 30, 30)];
    [registerBtnView addSubview:btn2];
    [btn2 setTitle:@"2" forState:UIControlStateNormal];
    btn2.backgroundColor = KBtnNoneColor;
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 15;
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(registerBtnView.frame), CGRectGetMaxY(passView.frame)+40, 80, 40)];
    [registerView addSubview:registerBtn];
    registerBtn.backgroundColor = KBtnColor;
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(reNextPageTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view sendSubviewToBack:registerView];
    registerBtn.userInteractionEnabled = YES;
}
- (void)reNextPageTap{
    [self.view bringSubviewToFront:registerNextView];
    [self.view sendSubviewToBack:registerView];
    [self.view sendSubviewToBack:loginView];
}
- (void)reNextPage{
    //registerTap
    registerNextView = [[UIView alloc] initWithFrame:CGRectMake(20, 150+64+40, kScreenWidth - 40, 220)];
    [self.view addSubview:registerNextView];
    registerNextView.backgroundColor = KWhiteColor;
    
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:registerNextView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5 , 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = registerNextView.bounds;
    maskLayer.path = fieldPath.CGPath;
    registerNextView.layer.mask = maskLayer;
    
    //交易密码view
    // 手机号码
    UIView *jiaoYiView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, registerNextView.bounds.size.width-40, 40)];
    [registerNextView addSubview:jiaoYiView];
    jiaoYiView.layer.masksToBounds = YES;
    jiaoYiView.layer.borderWidth = 1;
    jiaoYiView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    jiaoYiView.layer.cornerRadius = 3;
    
    UIImageView *jiaoYiIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [jiaoYiView addSubview:jiaoYiIconView];
    jiaoYiIconView.image = kImageNamed(passIcon);
    
    _paypasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, jiaoYiView.bounds.size.width-40-60, 40)];
    [jiaoYiView addSubview:_paypasswordTF];
    _paypasswordTF.placeholder = @"输入交易密码";
    _paypasswordTF.secureTextEntry = YES;
    //确认交易密码
    UIView *repaypasswordView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(jiaoYiView.frame)+20, registerNextView.bounds.size.width-40, 40)];
    [registerNextView addSubview:repaypasswordView];
    repaypasswordView.layer.masksToBounds = YES;
    repaypasswordView.layer.borderWidth = 1;
    repaypasswordView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    repaypasswordView.layer.cornerRadius = 3;
    
    UIImageView *repaypasswordIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [repaypasswordView addSubview:repaypasswordIconView];
    repaypasswordIconView.image = kImageNamed(passIcon);

    _repaypasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, repaypasswordView.bounds.size.width-40, 40)];
    _repaypasswordTF.secureTextEntry = YES;
    [repaypasswordView addSubview:_repaypasswordTF];
    _repaypasswordTF.placeholder = @"确认交易密码";
    _repaypasswordTF.delegate = self;
    
    // 下一步
    UIView *registerBtnView = [[UIView alloc] initWithFrame:CGRectMake(20, registerNextView.bounds.size.height-40-20, registerNextView.bounds.size.width-120, 40)];
    [registerNextView addSubview:registerBtnView];
    CGFloat bw = registerBtnView.bounds.size.width;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake((bw-120)/4-15, 0, 30, 30)];
    [registerBtnView addSubview:btn1];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    btn1.backgroundColor = KBtnNoneColor;
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 15;
    
    UIButton *btni0 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, 10, 10, 10)];
    btni0.backgroundColor = KBtnNoneColor;
    btni0.layer.masksToBounds = YES;
    btni0.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni0];
    
    UIButton *btni1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni0.frame)+10, 10, 10, 10)];
    btni1.backgroundColor = KBtnNoneColor;
    btni1.layer.masksToBounds = YES;
    btni1.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni1];
    
    UIButton *btni2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni1.frame)+10, 10, 10, 10)];
    btni2.backgroundColor = KBtnNoneColor;
    btni2.layer.masksToBounds = YES;
    btni2.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni2];
    
    UIButton *btni3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni2.frame)+10, 10, 10, 10)];
    btni3.backgroundColor = KBtnNoneColor;
    btni3.layer.masksToBounds = YES;
    btni3.layer.cornerRadius = 5;
    [registerBtnView addSubview:btni3];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btni3.frame)+10, 0, 30, 30)];
    [registerBtnView addSubview:btn2];
    [btn2 setTitle:@"2" forState:UIControlStateNormal];
    btn2.backgroundColor = KBtnColor;
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 15;
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(registerBtnView.frame), registerNextView.bounds.size.height-40-30, 80, 40)];
    [registerNextView addSubview:registerBtn];
    registerBtn.backgroundColor = KBtnColor;
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerTap) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.userInteractionEnabled = YES;
}
#pragma mark - 请求接口，注册新用户，注册成功后直接登陆
- (void)registerTap{
    if (_iphoneNumTF.text.length>0 && _vCodeTF.text.length>0 && _passwordTF.text.length>0&&_paypasswordTF.text.length>0&&_repaypasswordTF.text.length>0) {
        [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].registerURL parameter:@{@"username":_iphoneNumTF.text,@"password":_passwordTF.text,@"code":_vCodeTF.text,@"paypassword":_paypasswordTF.text,@"repaypassword":_repaypasswordTF.text,@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
            NSDictionary *responseObjectDic = responseObject;
            if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
                [self reqLogin];
            }else{
                [self showTost:[responseObjectDic objectForKey:@"msg"]];
            }
        } failure:nil];
    }else{
        [self showTost:@"请填写正确的信息"];
    }
}

- (void)reqLogin{
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].loginURL parameter:@{@"username":_iphoneNumTF.text,@"password":_passwordTF.text,@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *responseObjectDic = responseObject;
        if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_iphoneNumTF.text forKey:@"username"];
            NSDictionary *dd = [responseObjectDic objectForKey:@"data"];
            [userDefaults setObject:dd[@"token"] forKey:@"token"];
            [userDefaults setObject:dd[@"addr"] forKey:@"addr"];
            [self presentViewController:[[POHNavViewController alloc] initWithRootViewController:[POHMainViewController new]] animated:kAnmotain completion:nil];
            
        }else{
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }
        
    } failure:nil];
}

#pragma mark - 发送验证码
- (void)sendVCodeTap{
    if (_iphoneNumTF.text.length>0) {
        [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].getCodeURL parameter:@{@"username":_iphoneNumTF.text,@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
            NSDictionary *responseObjectDic = responseObject;
            if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
                [self showTost:[responseObjectDic objectForKey:@"msg"]];
                sendVcodeBtn.userInteractionEnabled = NO;
                timeDown = timer_count;
                timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            }else{
                [self showTost:[responseObjectDic objectForKey:@"msg"]];
            }
        } failure:nil];
    }else{
        [self showTost:txt(@"input_iphoneNum")];
    }
}

- (void)handleTimer{
    
    if(timeDown>0){
        timeDown = timeDown - 1;
        [sendVcodeBtn setImage:[kImageNamed(@"") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [sendVcodeBtn setTitle:[NSString stringWithFormat:@"%ds",timeDown] forState:UIControlStateNormal];
        sendVcodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        sendVcodeBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [sendVcodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else{
        [sendVcodeBtn setImage:[kImageNamed(sendVCodeIcon) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [sendVcodeBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        sendVcodeBtn.backgroundColor = KWhiteColor;
        [timer invalidate];
        sendVcodeBtn.userInteractionEnabled = YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)note{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY/2);
    }];
    
}

-(void)keyboardHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}


@end
