//
//  ScanQRViewController.h
//  微密
//
//  Created by wkl-mac-4 on 15/5/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanQRViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>{
    UIAlertView *_alertViewQR;
}
@property(nonatomic,strong)AVCaptureDevice *device;
@property(nonatomic,strong)AVCaptureDeviceInput *input;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)NSTimer *timer;
//扫描二维码或者条形码
@property(nonatomic,assign)BOOL isErWeiMa;
/**
 *  扫描成功返回的结果
 */
@property(nonatomic,copy)void (^QRCodeSucceedBlock) (ScanQRViewController *,NSString *);
/**
 *  扫描失败
 */
@property(nonatomic,copy)void (^QRCodeFailedBlock) (ScanQRViewController *);
@end
