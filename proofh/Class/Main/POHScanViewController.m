//
//  POHScanViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/9.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHScanViewController.h"
#import <SGQRCode.h>
#import "POHZhuanZhangViewController.h"

@interface POHScanViewController ()<SGQRCodeScanManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, copy) void (^scanFinish)(NSString *, NSError *);

@end

@implementation POHScanViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}
- (void)dealloc {
    [self removeScanningView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}
- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (_comeFromVC == ScanSuccessJumpComeFromZhuanZhang){
            __weak typeof(self) weakself = self;
            if (weakself.returnValueBlock) {
                weakself.returnValueBlock([obj stringValue]);
            }
            [self.navigationController popViewControllerAnimated:kAnmotain];
        }else{
            if (self.scanFinish) {
                //回调结果到页面上，也可以在此处做跳转操作,如果不想回去，直接注释下面的代码

                if (self.navigationController &&[self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.scanFinish([obj stringValue], nil);
                }
            }else{
                [self showTost:@"扫描失败"];
            }
        }
    } else {
        [self showTost:@"暂未识别出扫描的二维码"];
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (instancetype)initWithCanmOnFinish:(void (^)(NSString *result, NSError *error))finish{
    self = [super init];
    if (self) {
        self.scanFinish = finish;
    }
    return self;
}
@end
