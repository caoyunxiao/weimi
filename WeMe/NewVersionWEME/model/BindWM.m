//
//  BindWM.m
//  微密
//
//  Created by MacDev on 15/3/6.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BindWM.h"
#import "RequestEngine.h"

@interface BindWM()
/**
 *  在按钮变灰之前保存颜色值
 */
@property(nonatomic,strong)UIColor *boundBtnTempColor;

/**
 *  绑定imei号的button
 */
@property(nonatomic,strong)UIButton *boudnBtn;
@end
@implementation BindWM
{
    NSDictionary * _dic;
}
-(void)bindWMWithStr:(NSString*)str boudBtn:(UIButton*)boudBtn
{
    self.boudnBtn=boudBtn;
    if(str.length<=0)
    {
        _imeiStr = @"0";
    }
    else
    {
        _imeiStr = str;
    }
    [MBProgressHUD showMessage:@"主人绑定中" view:nil isShow:YES];
    boudBtn.enabled=NO;
    self.boundBtnTempColor=boudBtn.backgroundColor;
    boudBtn.backgroundColor=[UIColor grayColor];
    [RequestEngine getWeMeModelWithIMEIStr:str complete:^(NewWModel *model, NSString *errorCode) {

        if ([errorCode isEqualToString:@"0"])
        {

            [self legalObserver:model.status];
        }
        else if([errorCode isEqualToString:@"-1"])
        {
            Alert([MessageError getWithString:@"-1"]);
            [self legalObserver:@"3"];
        }
        else if ([errorCode isEqualToString:@"ME01001"])
        {
            [self legalObserver:@"4"];
        }else{
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
        }
       
    }];
}



- (void)legalObserver:(NSString *)legalString
{
    NSInteger  statusNum = [legalString integerValue];
    switch (statusNum)
    {
        case 0:
            [self bindWeMe];//绑定微密
            break;
        case 1:
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
            Alert(@"主人,该IMEI已经绑定了");
            break;
        case 2:
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
            Alert(@"主人,IMEI不合法哟");
            break;
        case 3:
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
            Alert(@"主人,绑定失败,请稍后再试吧");
            break;
        case 4:
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
            Alert(@"主人,绑定失败,请稍后再试吧");
            break;
        default:
            self.boudnBtn.enabled=YES;
            self.boudnBtn.backgroundColor=self.boundBtnTempColor;
            break;
    }
}
//#pragma mark --绑定微密请求函数 --
- (void)bindWeMe
{
    [RequestEngine getWeMeBindWithIMEIStr:_imeiStr complete:^(NSString *errorCode) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.lastObject animated:YES];
        self.boudnBtn.enabled=YES;
        self.boudnBtn.backgroundColor=self.boundBtnTempColor;
        if ([errorCode isEqualToString:@"0"])
        {
            [UserDefaults setObject:_imeiStr forKey:@"imeiString"];
            NSNotification *noti=[[NSNotification alloc]initWithName:refreshDeviceNotificationName object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:noti];
            [[NSNotificationCenter defaultCenter]postNotificationName:refreshMyViewUIKey object:nil];
            Alert(@"主人,您已成功绑定微密");
            
            [self bindWMSuccess];
            [self HasSereatKey];
        }
        else if([errorCode isEqualToString:@"ME18906"])
        {
            Alert(@"主人,该IMEI号无效哦");
        }
        else if([errorCode isEqualToString:@"ME01001"])
        {
            Alert(@"主人,绑定失败,请稍后再试吧");
        }
    }];
}
//#pragma mark -- 是否绑定押金密码
- (void)HasSereatKey
{
    ///是否绑定押金密码
    [RequestEngine judgeWeMeHasSereat:^(NSString *hasPassword, NSString *errorCode) {
        if ([errorCode isEqualToString:@"0"])
        {
        }
        else
        {
            Alert([MessageError getWithString:errorCode]);
        }
        if (hasPassword)
        {
            _dic = @{kCash:hasPassword};
            [self postNotification];
        }
    }];
}
////是否设置押金密码
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:PledgePwdObserver object:self userInfo:_dic];
}
////绑定微密成功
- (void)bindWMSuccess
{
    [[NSNotificationCenter defaultCenter]postNotificationName:BINDWMSUCCESS object:self];
}
@end
