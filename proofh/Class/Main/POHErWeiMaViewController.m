//
//  POHErWeiMaViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHErWeiMaViewController.h"
#import <SGQRCode.h>

@interface POHErWeiMaViewController ()

@end

@implementation POHErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self navRightItem];
    [self subview];
    self.title = txt(@"tip_shouKuan");
}

- (void)subview{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:backImageView];
    backImageView.image = kImageNamed(bgviewIcon);
    backImageView.userInteractionEnabled = YES;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, kScreenWidth - 40, kScreenWidth  - 40)];
    [backImageView addSubview:bgView];
    bgView.image = kImageNamed(@"erweima");
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgView.bounds.size.width, 40)];
    [bgView addSubview:label];
    label.text = txt(@"tip_saomiao");
    label.textColor = KBtnColor;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    
    CGFloat h = CGRectGetMaxY(label.frame)+10;
    CGFloat wAndW = kScreenWidth  - 40 - h-50;
    CGFloat x =(kScreenWidth  - 40 - wAndW)/2;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, h, wAndW, wAndW)];
    [bgView addSubview:bgImageView];
    bgImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] imageViewWidth:bgView.bounds.size.width-80];
    // UIImagePNGRepresentation(imageView.image)

    
    UIImageView *bobgiconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(bgView.frame), kScreenWidth-40, 40+20)];;
    [backImageView addSubview:bobgiconView];
    bobgiconView.image = kImageNamed(@"bgerweima");
    bobgiconView.userInteractionEnabled = YES;
    
    UIImageView *xuXian = [[UIImageView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(bgView.frame), kScreenWidth-80, 2)];
    [backImageView addSubview:xuXian];
    xuXian.image = kImageNamed(@"xuzian");
    

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-80-60, 40)];
    [bobgiconView addSubview:label1];
    [POHHttpReq requestWithRequestURL:[POHAPI shareInstance].geterwei parameter:@{@"appid":[POHAPI shareInstance].appid} requestSuccessBlock:^(NSDictionary *responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"msg"] forKey:@"addr"];
        label1.text = [responseObject objectForKey:@"msg"];

    } failure:nil];
    label1.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"addr"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80-50, 10, 60, 40)];
    [bobgiconView addSubview:btn];
    btn.backgroundColor = KWhiteColor;
    [btn setTitle:txt(@"tip_copy") forState:UIControlStateNormal];
    [btn setTitleColor:KBtnColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fuzhiTap) forControlEvents:UIControlEventTouchUpInside];
}
- (void)fuzhiTap{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = [[NSUserDefaults standardUserDefaults] objectForKey:@"addr"];
    if (pasteboard == nil) {
        [self showTost:txt(@"tip_copyfailed")];
    }else{
        [self showTost:txt(@"tip_copysuccess")];
    }
}
/*
- (void)navRightItem{
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"保存图片" style:UIBarButtonItemStylePlain target:self action:@selector(xiaZaiTuPian)];
    self.navigationItem.rightBarButtonItem = releaseButon;
}

#pragma mark - 下载图片，保存到本地
- (void)xiaZaiTuPian{
    UIImage *image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] imageViewWidth:100];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"addr"], @".png"]];
    [self writeImage:image toFileAtPath:pngPath];


}


- (BOOL)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath {
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"]) {
            imageData = UIImagePNGRepresentation(image);
        } else {
            // the rest, we write to jpeg
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e) {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
    
}*/
@end
