//
//  ScanQRViewController.m
//  微密
//
//  Created by wkl-mac-4 on 15/5/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ScanQRViewController.h"
#import "DetailsOfAnchorViewController.h"
#import "DetailsOfChannelViewController.h"
#import "ManagerViewController.h"
//static const float LineMinY = 185;
//static const float LineMaxY = 385;
//static const float ScanViewWidth = 200;
//static const float ScanViewHeight = 200;

@interface ScanQRViewController () <UIAlertViewDelegate>
@property(nonatomic,assign)CGFloat lineMinY;
@property(nonatomic,assign)CGFloat lineMaxY;
@property(nonatomic,assign)CGFloat scanViewWidth;
@property(nonatomic,assign)CGFloat scanViewHeight;
@end

@implementation ScanQRViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫描二维码";
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    if (self.isErWeiMa == YES) {
        self.lineMinY = 185;
        self.lineMaxY = 385;
        self.scanViewWidth = 200;
        self.scanViewHeight = 200;
    } else {
        self.lineMinY = 185;
        self.lineMaxY = 285;
        self.scanViewWidth =300;
        self.scanViewHeight = 100;
    }
    
    [self setUpScan];
    [self setMask];
    [self startScanQR];
   
}
- (void)startScanQR {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/20 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [self.session startRunning];
}
- (void)animation {
    
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag) {
        frame.origin.y = _lineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= _lineMinY)
        {
            if (_line.frame.origin.y >= _lineMaxY - 12)
            {
                frame.origin.y = _lineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
}

- (void)goBack
{
    [self stopScanQR];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)stopScanQR {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.session stopRunning];
}
- (void)setUpScan {
    
    //Device
    
     AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    //Input
    
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        //NSLog(@"没有相机");
        return;
    }
   
    
    //Output
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设定扫描框的大小;坐标,宽高要反过来写
    [output setRectOfInterest:CGRectMake(self.lineMinY/ScreenHeight, (ScreenWidth-self.scanViewWidth)/2/ScreenWidth, self.scanViewHeight/ScreenHeight, self.scanViewWidth/ScreenWidth)];
    
    //Session
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //以下为设置扫描的精度
    
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]];

    
    //Preview
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    self.session = session;
    self.preview = preview;
    
    [self.session startRunning];
}


- (void)setMask {
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 300) / 2.0, self.lineMinY, 300, 12 * 300 / ScreenWidth)];
    if (self.isErWeiMa == NO) {
        _line.frame = CGRectMake((ScreenWidth - 300) / 2.0, self.lineMinY+self.scanViewHeight/2, 300, 12 * 300 / ScreenWidth);
    } else {
        
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(self.scanViewHeight-10);
        scanNetAnimation.duration = 1.5;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_line.layer addAnimation:scanNetAnimation forKey:nil];
    }
    [_line setImage:[UIImage imageNamed:@"ScanQRLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.lineMinY)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineMinY, (ScreenWidth - self.scanViewWidth) / 2.0, self.scanViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - CGRectGetMaxX(leftView.frame), self.lineMinY, CGRectGetMaxX(leftView.frame), self.scanViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = ScreenHeight - self.lineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineMaxY, ScreenWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个角的图片

    UIImage *cornerImage = [UIImage imageNamed:@"ScanQR1"];
    
    //左上角
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMaxY(upView.frame), cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR2"];
    
    //右上角
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame)-cornerImage.size.width, CGRectGetMaxY(upView.frame), cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR3"];
    
    //左下角
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) , CGRectGetMinY(downView.frame)-cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;

    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR4"];
    
    //右下角
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame)-cornerImage.size.width, CGRectGetMinY(downView.frame)-cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, self.scanViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码/条形码置于框内,即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) ,self.lineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame), self.scanViewHeight)];
    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    scanCropView.layer.borderWidth = 1.0;
    CALayer *layer = [scanCropView layer];
    [self.view.layer insertSublayer:layer atIndex:1];

    
}
#pragma mark AVCaptureMetaddataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    //扫描成功后返回数组
    if ([metadataObjects count] >0) {
        //停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject =[metadataObjects objectAtIndex:0];
         stringValue = metadataObject.stringValue;
        if (stringValue)
        {
            [self stopScanQR];
            //扫描成功后在这里做界面跳转
            //Alert(stringValue);
            if(_isErWeiMa)
            {
                [self jumpViewWithStr:stringValue];
            }
            else
            {
                NSDictionary * dic = @{@"tiaoxinma":stringValue};
                //扫描到了条形码
                [[NSNotificationCenter defaultCenter]postNotificationName:@"tiaoxinma" object:self userInfo:dic];
                [self dismissViewControllerAnimated:YES completion:nil];
            }

        }
        //NSLog(@"Scan--%@",stringValue);
    }
}
#pragma mark --扫描成功后跳转页面--
- (void)jumpViewWithStr:(NSString *)str
{
    if ([str rangeOfString:@"|"].location ==NSNotFound)
    {
        NSString *strNew = [NSString stringWithFormat:@"主人,你扫描的是:%@",str];
        _alertViewQR = [[UIAlertView alloc]initWithTitle:@"提示" message:strNew delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [_alertViewQR show];
        //Alert(strNew);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString * channelNumber = [[str componentsSeparatedByString:@"|"]objectAtIndex:0];
    
    [RequestEngine getSecretChannelInfoWithChannelNumber:channelNumber completed:^(NSString *errorCode, NewChannelModel *model) {
        if ([errorCode isEqualToString:@"0"]) {
            NSString * type = [[str componentsSeparatedByString:@"|"]objectAtIndex:1];
            switch ([type integerValue])
            {
                case 1:
                {
                    //群聊
                    DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
                    vc.uniqueCode = model.InviteUniqueCode;
                    vc.channelNumber = channelNumber;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //群聊
                    DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
                    vc.uniqueCode = model.InviteUniqueCode;
                    vc.channelNumber = channelNumber;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    //主播
                    DetailsOfChannelViewController * vc = [[DetailsOfChannelViewController alloc]init];
                    vc.channelNumber = channelNumber;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }

    }];
}
#pragma mark - alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==_alertViewQR)
    {
        [self startScanQR];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startScanQR];   
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(((ScreenHeight-asize.height)/ 2.0)/ ScreenHeight, ((ScreenWidth - asize.width)/ 2.0)/ ScreenWidth, asize.height / ScreenHeight, asize.width / ScreenWidth);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
