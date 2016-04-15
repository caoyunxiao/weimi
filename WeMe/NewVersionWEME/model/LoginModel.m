//
//  LoginModel.m
//  微密
//
//  Created by longlz on 14-7-21.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "LoginModel.h"
#import "HTTPPostManger.h"
#import "HeaderModel.h"


@implementation LoginModel


- (int)loginSynchronousWithName:(NSString *)name pwd:(NSString *)pwd
{
   NSString *bodyString = [NSString stringWithFormat:@"daokePassword=%@&username=%@&%@",pwd,name,SecretOrAppkey];
   NSData *data =  [HTTPPostManger requestSynchronization:LOGINURL(@"checkLogin.do") bodyString:bodyString];
    if (data == nil) {
        return 4;
    }
    if ([data length] == 0)
    {
        return 3;
    }
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)object;
        
        if (dict == nil) {
            return 3;
        }
        
        if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            NSDictionary *resultStr = [dict objectForKey:@"RESULT"];
            NSString *accountIDStr = [resultStr objectForKey:@"accountID"];
            NSString *mobileStr = [resultStr objectForKey:@"mobile"];
            NSString *nameStr = [resultStr objectForKey:@"name"];
            NSString *nicknameStr = [resultStr objectForKey:@"nickname"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:accountIDStr forKey:@"accountID"];
            [defaults setObject:mobileStr forKey:@"mobile"];
            [defaults setObject:nicknameStr forKey:@"nickname"];
            [defaults setObject:nameStr forKey:@"name"];
            [defaults setObject:name forKey:kNameString];
            [defaults setObject:pwd forKey:kpassworldString];
            [defaults setObject:nil forKey:kFamilyPhoneOrIMEI];
            [defaults setObject:nil forKey:kAppStation];
            [defaults setObject:nil forKey:kWXUID];
            [defaults synchronize];
            
            [HeaderModel sharedHeaderModel].accountID = [resultStr objectForKey:@"accountID"];
            [PersonInfo sharePersonInfo].accountIDString = [resultStr objectForKey:@"accountID"];
            [PersonInfo sharePersonInfo].nameString = [resultStr objectForKey:@"name"];
            [PersonInfo sharePersonInfo].nicknameString = [resultStr objectForKey:@"nickname"];
            [PersonInfo sharePersonInfo].iconString = [defaults objectForKey:@"iconString"];
            [PersonInfo sharePersonInfo].senderUserHeadName = [defaults objectForKey:@"iconString"];
            
            if(nicknameStr.length==0||nicknameStr==nil)
            {
                return 4;
            }
            else
            {
                return 0;
            }
        }
        else if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18063"])
        {
            return 1;
        }
        else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18061"])
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
    else
    {
        return 3;
    }
}

+ (BOOL)getUserInfo
{
    BOOL isShow;
    NSString *bodyString = [NSString stringWithFormat:@"accountID=%@&%@",[PersonInfo sharePersonInfo].accountIDString,SecretOrAppkey];
    NSData *data =  [HTTPPostManger requestSynchronization:LOGINURL(@"getUserInfo.do") bodyString:bodyString];
    if (data == nil||data.length==0)
    {
        return YES;
    }
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *fullPath = [RequestEngine filePath:@"getUserInfo"];
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        [responseObject writeToFile:fullPath atomically:YES];
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        NSDictionary *resultDic = [responseObject objectForKey:@"RESULT"];
        [Request1617 putInforInNSUserDefaults:resultDic];
        if([errorcode isEqualToString:@"0"])
        {
            BOOL isPresentViewController = NO;
            //获取用户信息成功
            NSString *nicknameString = [resultDic objectForKey:@"nickname"];
            NSString *areaStr = [resultDic objectForKey:@"userAreaCode"];
            NSString *sexString = [resultDic objectForKey:@"gender"];
            if(nicknameString==nil||[nicknameString isEqual:[NSNull null]]||nicknameString.length==0)
            {
                isPresentViewController = YES;
            }
            if(areaStr==nil||[areaStr isEqual:[NSNull null]]||areaStr.length==0)
            {
                isPresentViewController = YES;
            }
            if(sexString==nil||[sexString isEqual:[NSNull null]]||sexString.length==0)
            {
                isPresentViewController = YES;
            }
            if(isPresentViewController)
            {
                isShow = NO;
            }
            else
            {
                isShow = YES;
            }
        }
        else
        {
            isShow = YES;
        }
    }
    else
    {
        isShow = YES;
    }
    return isShow;
}

+ (NSInteger)wxLoginSynchronousWith:(NSString *)uid
{
    NSString *bodyString  = [NSString stringWithFormat:@"%@&account=%@&loginType=5",SecretOrAppkey,uid];
    
    NSData *data = [HTTPPostManger requestSynchronization:LOGINURL(WXLOGIN) bodyString:bodyString];
    
    if ([data length] == 0) {
        return 3;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (dict == nil)
    {
        return 3;
    }
    
    if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *accoutID = [[dict objectForKey:@"RESULT"] objectForKey:@"accountID"];
        NSString *nickname = [[dict objectForKey:@"RESULT"] objectForKey:@"nickname"];
        
        [PersonInfo sharePersonInfo].accountIDString = accoutID;
        [PersonInfo sharePersonInfo].nicknameString = nickname;
        [PersonInfo sharePersonInfo].iconString = [defaults objectForKey:@"iconString"];
        [PersonInfo sharePersonInfo].senderUserHeadName = [defaults objectForKey:@"iconString"];
        
        [defaults setObject:nil forKey:kNameString];
        [defaults setObject:nil forKey:kpassworldString];
        [defaults setObject:nil forKey:kFamilyPhoneOrIMEI];
        [defaults setObject:nil forKey:kAppStation];
        [defaults setObject:uid forKey:kWXUID];
        [defaults synchronize];
        
        NSDictionary *dict = [LoginModel getIMEIAndPhone];
        NSString *phoneStr= [dict objectForKey:@"phone"];
        if(phoneStr.length != 11)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 2;
    }
}
//获取IMEI号和手机号
+ (NSDictionary *)getIMEIAndPhone
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&accountID=%@",SecretOrAppkey,[PersonInfo sharePersonInfo].accountIDString];
    NSData *data = [HTTPPostManger requestSynchronization:LOGINURL(@"getImeiPhone.do") bodyString:bodyString];
    if(data==nil||data.length==0)
    {
        return nil;
    }
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        NSDictionary *resultDic = [responseObject objectForKey:@"RESULT"];
        
        if([errorcode isEqualToString:@"0"])
        {
            return resultDic;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

+ (MoreModely *)getAdvertisementViewImageWithDic
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&accountID=%@&isCountDownAd=1",SecretOrAppkey,[PersonInfo sharePersonInfo].accountIDString];
    NSData *data = [HTTPPostManger requestSynchronization:LOGINURL(@"v2/getMoreList") bodyString:bodyString];
    if(data==nil||data.length==0)
    {
        return nil;
    }
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
        if([errorcode isEqualToString:@"0"])
        {
            NSDictionary *adCountDown = [resultDict objectForKey:@"adCountDown"];
            MoreModely *adCountDownModels = [MoreModely getModelWithDic:adCountDown];
            [PersonInfo sharePersonInfo].adCountDownModels = adCountDownModels;
            return adCountDownModels;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }

}

























@end
