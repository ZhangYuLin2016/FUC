//
//  POHChangPayPasswordViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/8.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHChangPayPasswordViewController.h"

@interface POHChangPayPasswordViewController (){
    UIButton *sendVcodeBtn;
    int timeDown;
    NSTimer *timer;
}

@property (nonatomic, strong) UITextField *vcodeTF;
@property (nonatomic, strong) UITextField *inputNewPassTF;
@property (nonatomic, strong) UITextField *sureinputNewPassTF;

@end

@implementation POHChangPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = txt(@"tip_Modifyingthetransactionpassword");
    CGFloat tfH = 40;
    
    _vcodeTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40-30, tfH)];
    [self.view addSubview:_vcodeTF];
    _vcodeTF.placeholder = txt(@"input_vcode");
    
    sendVcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40-20, 10, 30, 30)];
    [self.view addSubview:sendVcodeBtn];
    [sendVcodeBtn setImage:[kImageNamed(sendVCodeIcon) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [sendVcodeBtn addTarget:self action:@selector(sendVCodeTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    _inputNewPassTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_vcodeTF.frame), kScreenWidth-40, tfH)];
    [self.view addSubview:_inputNewPassTF];
    _inputNewPassTF.placeholder = txt(@"tip_newPass");
    _inputNewPassTF.secureTextEntry = YES;
    
    _sureinputNewPassTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_inputNewPassTF.frame), kScreenWidth-40, tfH)];
    [self.view addSubview:_sureinputNewPassTF];
    _sureinputNewPassTF.placeholder = txt(@"tip_surenewPass");
    _sureinputNewPassTF.secureTextEntry = YES;
    
    
    
    UIView *bottomView = [[UIView alloc] init];
    if (Is_Iphone_X) {
        bottomView.frame = CGRectMake(0, kScreenHeight-60-120, kScreenWidth, 60);
    }else{
        bottomView.frame = CGRectMake(0, kScreenHeight-60-64, kScreenWidth, 60);
    }
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20-120, 30)];
    label1.text = txt(@"tip_sureit");
    label1.textColor = kTextColor;
    [bottomView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth-20-120, 30)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = txt(@"tip_sureitdetails");
    label2.textColor = kTextColor;
    [bottomView addSubview:label2];
    
    UIButton *baoCunBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-120, 0, 120, 60)];
    [bottomView addSubview:baoCunBtn];
    baoCunBtn.backgroundColor = KBtnColor;
    [baoCunBtn setTitle:txt(@"tip_baocun") forState:UIControlStateNormal];
    [baoCunBtn addTarget:self action:@selector(baocunTap) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 请求接口，发送验证码
- (void)sendVCodeTap{
    
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].getCodeURL parameter:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *responseObjectDic = responseObject;
        if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
            sendVcodeBtn.userInteractionEnabled = NO;
            timeDown = timer_count;
            timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }else{
            [self showTost:[responseObjectDic objectForKey:@"msg"]];
        }
    } failure:nil];
    
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



#pragma mark - 请求接口，修改交易密码
- (void)baocunTap{
    if (_inputNewPassTF.text.length>0&&_sureinputNewPassTF.text.length>0 &&_vcodeTF.text.length>0) {
        [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].changePayPasswordURL parameter:@{@"newpaypassword":_inputNewPassTF.text, @"renewpaypassword":_sureinputNewPassTF.text, @"code":_vcodeTF.text, @"username":myusername, @"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
            NSDictionary *responseObjectDic = responseObject;
            if ([[responseObjectDic objectForKey:@"flag"] isEqualToString:@"Success"]) {
                [self showTost:[responseObjectDic objectForKey:@"msg"]];
            }else{
                [self showTost:[responseObjectDic objectForKey:@"msg"]];
            }
        } failure:nil];
    }
}

@end
