//
//  ShareErWeiMaViewController.m
//  微密
//
//  Created by wemeDev on 15/5/30.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShareErWeiMaViewController.h"
#import "MobClick.h"
#import "CreatTableViewCell.h"
#import "ZHPickView.h"
#import "CityPickView.h"
#import "NewChannelModel.h"
#import "QRCodeGenerator.h"
#import "newInputViewController.h"
#import <ShareSDK/ShareSDK.h>



@interface ShareErWeiMaViewController ()<UMSocialUIDelegate,UMSocialDataDelegate>

@end

@implementation ShareErWeiMaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.nameLabel.text = [NSString stringWithFormat:@"群聊频道名称:%@",self.nameStr];
    self.channelNumber.text = [NSString stringWithFormat:@"频道号:%@",self.number];
    //self.twoCodeImageView.image = [QRCodeGenerator qrImageForString:self.imageStr imageSize:self.twoCodeImageView.frame.size.width];
    self.twoCodeImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@|2",self.number] imageSize:self.twoCodeImageView.bounds.size.width];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^(){
        //关掉注册controller
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_B" object:nil userInfo:nil];
    }];
}

#pragma mark - 分享
- (void)shareButtonClick
{
    NSMutableString *shareStr = [[NSMutableString alloc]initWithFormat:@"http://open.daoke.me/channelQRCode?inviteUniqueCode=%@|3&channelName=%@",self.number,self.nameStr];
    NSString *titleStr = [NSString stringWithFormat:@"小伙伴们，我正在使用WEME群聊频道，扫一扫加入进来和我一起聊天吧~%@",shareStr];
    NSString *imagePath = [self screenshot];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKey
                                      shareText:titleStr
                                     shareImage:[UIImage imageWithContentsOfFile:imagePath]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
//    
//    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:@"分享" images:@[[UIImage imageWithContentsOfFile:imagePath]] url:[NSURL URLWithString:shareStr] title:titleStr type:SSDKContentTypeImage];
//
//    
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

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
                    [self dismissViewControllerAnimated:YES completion:^(){
                        //关掉注册controller
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_B" object:nil userInfo:nil];}];
    }else{
        Alert(@"主人,分享失败了哦");
    }
}
#pragma mark - 把生成的二维码保存到本地
- (NSString *)screenshot
{
    UIImage *image = self.twoCodeImageView.image;
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


/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
//- (void)showShareActionSheet:(UIView *)view
//{
//    /**
//     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
//     **/
//    __weak ShareErWeiMaViewController *theController = self;
//    
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
//    [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                     images:imageArray
//                                        url:[NSURL URLWithString:@"http://mob.com"]
//                                      title:@"分享标题"
//                                       type:SSDKContentTypeAuto];
//    
//    //1.2、自定义分享平台（非必要）
//    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
//    //添加一个自定义的平台（非必要）
//    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
//                                                                                  label:@"自定义"
//                                                                                onClick:^{
//                                                                                    
//                                                                                    //自定义item被点击的处理逻辑
//                                                                                    NSLog(@"=== 自定义item被点击 ===");
//                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
//                                                                                                                                        message:nil
//                                                                                                                                       delegate:nil
//                                                                                                                              cancelButtonTitle:@"确定"
//                                                                                                                              otherButtonTitles:nil];
//                                                                                    [alertView show];
//                                                                                }];
//    [activePlatforms addObject:item];
//    
//    //设置分享菜单栏样式（非必要）
//    //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
//    //        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//    //        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//    //        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
//    //        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
//    //        [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
//    //        [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
//    //        [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
//    
//    //2、分享
//    [ShareSDK showShareActionSheet:view
//                             items:activePlatforms
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   
//                   switch (state) {
//                           
//                       case SSDKResponseStateBegin:
//                       {
//                           [theController showLoadingView:YES];
//                           break;
//                       }
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           else
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           break;
//                       }
//                       case SSDKResponseStateCancel:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//                   
//                   if (state != SSDKResponseStateBegin)
//                   {
//                       [theController showLoadingView:NO];
//                       [theController.tableView reloadData];
//                   }
//                   
//               }];
//    
//    //另附：设置跳过分享编辑页面，直接分享的平台。
//    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
//    //                                                                         items:nil
//    //                                                                   shareParams:shareParams
//    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//    //                                                           }];
//    //
//    //        //删除和添加平台示例
//    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
//    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
