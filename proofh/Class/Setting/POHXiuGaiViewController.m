//
//  POHXiuGaiViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHXiuGaiViewController.h"

@interface POHXiuGaiViewController (){
    UIButton *sendVcodeBtn;
    int timeDown;
    NSTimer *timer;
}

@property (nonatomic, strong) UITextField *oldPassTF;
@property (nonatomic, strong) UITextField *vcodeTF;
@property (nonatomic, strong) UITextField *inputNewPassTF;
@property (nonatomic, strong) UITextField *sureinputNewPassTF;

@end

@implementation POHXiuGaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = txt(@"tip_xiuGaipass");
    [self initMyView];
    
}

- (void)initMyView{
    CGFloat tfH = 40;
    _oldPassTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40, tfH)];
    [self.view addSubview:_oldPassTF];
    _oldPassTF.placeholder = txt(@"tip_oldPass");
    
    _vcodeTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_oldPassTF.frame), kScreenWidth-40-30, tfH)];
    [self.view addSubview:_vcodeTF];
    _vcodeTF.placeholder = txt(@"input_vcode");
    
    sendVcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40-20, 10+tfH, 30, 30)];
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
    [baoCunBtn addTarget:self action:@selector(baocunTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

#pragma mark - 请求接口，确认修改密码
- (void)baocunTap:(UIButton *)tap{
    if (_inputNewPassTF.text.length > 0 && _sureinputNewPassTF.text.length > 0 && _oldPassTF.text.length > 0) {
        if ([_inputNewPassTF.text isEqualToString:_sureinputNewPassTF.text]) {
            [self req];
        }else{
            [self showTost:@"请检查两次新密码是否一样"];
        }
    }else{
        [self showTost:@"请完善信息"];
    }
}
- (void)req{
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].changepasswordURL parameter:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"oldpassword":_oldPassTF.text,@"newpassword":_inputNewPassTF.text,@"code":_vcodeTF.text,@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
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
@end
