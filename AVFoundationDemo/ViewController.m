//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by 刘瑞刚 on 15/11/12.
//  Copyright © 2015年 刘瑞刚. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeViewController.h"

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;

- (IBAction)startScanner:(id)sender;
- (IBAction)openSystemLight:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人小助手";
    
    [self configureViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureViews {
    if (!_button) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor redColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setTitle:@"扫描二维码" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(startScanner:) forControlEvents:UIControlEventTouchUpInside];
        _button = button;
        [self.view addSubview:_button];
    }
    
    if (!_lightButton) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor redColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setTitle:@"打开手电筒" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openSystemLight:) forControlEvents:UIControlEventTouchUpInside];
        _lightButton = button;
        [self.view addSubview:_lightButton];
    }
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-25);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 45));
    }];
    
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-80, 45));
    }];
}


- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (IBAction)startScanner:(id)sender {
//    UIButton *button = (UIButton *)sender;
//    button.selected = !button.selected;
//    if (button.selected) {
//        [self startReading];
//    } else {
//        [self stopReading];
//    }
    
    ScanCodeViewController *scanCodeViewController = [[ScanCodeViewController alloc]init];
    scanCodeViewController.sucessScanBlock = ^(NSString *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"二维码扫描结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    };
    [self.navigationController pushViewController:scanCodeViewController animated:YES];
}

- (IBAction)openSystemLight:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self systemLightSwitch:YES];
        [_lightButton setTitle:@"关闭手电筒" forState:UIControlStateNormal];
    } else {
        [self systemLightSwitch:NO];
        [_lightButton setTitle:@"打开手电筒" forState:UIControlStateNormal];
    }

}

-(void)buttonCancelAction {
    
}

-(void)buttonOkAction {
    
}

//- (BOOL)startReading
//{
//    // 获取 AVCaptureDevice 实例
//    NSError * error;
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    // 初始化输入流
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
//    if (!input) {
//        NSLog(@"%@", [error localizedDescription]);
//        return NO;
//    }
//    // 创建会话
//    _captureSession = [[AVCaptureSession alloc] init];
//    // 添加输入流
//    [_captureSession addInput:input];
//    // 初始化输出流
//    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
//    // 添加输出流
//    [_captureSession addOutput:captureMetadataOutput];
//
//    // 创建dispatch queue.
//    dispatch_queue_t dispatchQueue;
//    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
//    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
//    // 设置元数据类型 AVMetadataObjectTypeQRCode
//    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
//
//    // 创建输出对象
//    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
//    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    [_videoPreviewLayer setFrame:_sanFrameView.layer.bounds];
//    [_sanFrameView.layer addSublayer:_videoPreviewLayer];
//    // 开始会话
//    [_captureSession startRunning];
//
//    return YES;
//}
//
//- (void)stopReading
//{
//    // 停止会话
//    [_captureSession stopRunning];
//    _captureSession = nil;
//}
//
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
//      fromConnection:(AVCaptureConnection *)connection
//{
//    if (metadataObjects != nil && [metadataObjects count] > 0) {
//        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
//        NSString *result;
//        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
//            result = metadataObj.stringValue;
//        } else {
//            NSLog(@"不是二维码");
//        }
//        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
//    }
//}
//
//- (void)reportScanResult:(NSString *)result
//{
//    [self stopReading];
//    if (!_lastResult) {
//        return;
//    }
//    _lastResult = NO;
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"二维码扫描" message:result preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        _lastResult = YES;
//    }];
//    [alertController addAction:okAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}


@end
