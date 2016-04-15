//
//  ShowBigErWeiMaViewController.m
//  微密
//
//  Created by wemeDev on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShowBigErWeiMaViewController.h"
#import "QRCodeGenerator.h"
#import <ShareSDK/ShareSDK.h>

@interface ShowBigErWeiMaViewController ()

@end

@implementation ShowBigErWeiMaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = @"二维码";
    self.bigView.layer.masksToBounds = YES;
    self.bigView.layer.cornerRadius = 5;
    self.bigView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1].CGColor;
    self.bigView.layer.borderWidth = 1.0;
    self.erWeiMaImage.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",_model.channelNumber,_type] imageSize:self.erWeiMaImage.bounds.size.width];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    self.nameTitle.text = _model.name;
    self.classTitle.text = [NSString stringWithFormat:@"分类:%@",_model.catalogName];
    self.zhuBoLabel.text = _isZhubo?[NSString stringWithFormat:@"主播:%@",_model.chiefAnnouncerName]:[NSString stringWithFormat:@"管理员:%@",_model.adminName];
    self.fansLabel.text =  _isZhubo?[NSString stringWithFormat:@"粉丝: %@/%@",_model.onlineCount,_model.userCount]:[NSString stringWithFormat:@"成员: %@/%@",_model.onlineCount,_model.userCount];
}


#pragma mark - 分享
- (void)shareButtonClick
{
    NSMutableString *shareStr = [[NSMutableString alloc]initWithFormat:@"http://open.daoke.me/channelQRCode?inviteUniqueCode=%@%@&channelName=%@",_model.number,_type,_model.name];
    NSString *titleStr = @"我正在使用WEME群聊频道,快点来和我聊天吧!";
    NSString *imagePath = [self screenshot];
    id<ISSContent> publishContent = [ShareSDK content:@"分享" defaultContent:@"WEME2.0" image:[ShareSDK imageWithPath:imagePath] title:titleStr url:shareStr description:@"#分享描述" mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             [self dismissViewControllerAnimated:YES completion:^(){
                 //关掉注册controller
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_B" object:nil userInfo:nil];
             }];
         }
         else if (state == SSResponseStateFail)
         {
             Alert(@"主人,分享失败了哦");
         }
     }];
    
    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:@"分享" images:@[[UIImage imageWithContentsOfFile:imagePath]] url:[NSURL URLWithString:shareStr] title:titleStr type:SSDKContentTypeImage];
//    
//    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        if (state == SSDKResponseStateSuccess)
//        {
//            [self dismissViewControllerAnimated:YES completion:^(){
//                //关掉注册controller
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_B" object:nil userInfo:nil];
//            }];
//            NSLog(@"分享成功");
//        }
//        else if (state == SSDKResponseStateFail)
//        {
//            Alert(@"主人,分享失败了哦");
//        }
//    }];
}
#pragma mark - 把生成的二维码保存到本地
- (NSString *)screenshot
{
    UIImage *image = self.erWeiMaImage.image;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
    NSString *imagePath = [path stringByAppendingFormat:@"/shareImage.png"];
    BOOL isDir= NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES])
    {
        return imagePath;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
