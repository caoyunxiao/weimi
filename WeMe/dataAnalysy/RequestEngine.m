//
//  RequestEngine.m
//  DemoText
//
//  Created by MacDev on 14/12/25.
//  Copyright (c) 2014年 MacDev. All rights reserved.
//

#import "RequestEngine.h"
#import "AFHTTPRequestOperationManager.h"
#import "WMChannelInfo.h"
#import "NewRootViewController.h"
#import "ChannelModely.h"
#import "FriendModel.h"
#import "RankModel.h"
#import "RequestManager.h"
#import "TKAddressBook.h"
#import "MoneyModely.h"
#import "DepositHisotryInfo.h"
#import "HistoryModel.h"

@implementation RequestEngine

////20,验证微密的合法性
+(void)getWeMeModelWithIMEIStr:(NSString *)imeiStr complete:(void(^)(NewWModel * model,NSString * errorCode))completed
{
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"IMEI":imeiStr};
    [manager POST:LOGINURL(@"getMirrtalkInfoByImei.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"------%@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                NewWModel * model = [NewWModel getWeMeModelWithDic:resultDict];
                if ([model.legalIMEI integerValue] == 1)
                {
                    if ([model.usableIMEI integerValue] == 1)
                    {
                        model.status = @"0";
                    }
                    else
                    {
                        model.status = @"1";
                    }
                }
                else
                {
                    model.status = @"2";
                }
                if (completed)
                {
                    completed(model,errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(nil,errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(nil,@"-1");
        }
    }];
}
/////21,绑定微密
+(void)getWeMeBindWithIMEIStr:(NSString *)imeiStr complete:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"IMEI":imeiStr,@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"userBindAccountMirrtalk.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                if ([imeiStr isEqualToString:@"0"])
                {
                    [PersonInfo sharePersonInfo].IMEIString = @"";
                }
                else
                {
                    [defaults setValue:imeiStr forKey:BIND];
                    [defaults synchronize];
                    [PersonInfo sharePersonInfo].IMEIString = imeiStr;
                }
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            if (completed)
            {
                completed(@"-1");
            }
        }
    }];
}
/////22,判断微密是否设置押金密码
+(void)judgeWeMeHasSereat:(void(^)(NSString* hasPassword,NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"judgeExistPassword.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSDictionary * dataDic = [responseObject objectForKey:@"RESULT"];
                NSString * hasPassword = [dataDic objectForKey:@"hasPassword"];
                if ([hasPassword integerValue] == 0)
                {
                    if (completed)
                    {
                        completed(@"0",errorcode);
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(@"1",errorcode);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"2",errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            if (completed)
            {
                completed(nil,@"-1");
            }
        }
    }];
}
/////23,接触绑定微密
+(void)disconnestWithWeMe:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    
    [manager POST:LOGINURL(@"disconnectAccount.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            if (completed)
            {
                completed(@"-1");
            }
        }
    }];
}




////25,获取IMEI手机号
+(void)getIMEIAndPhone:(void(^)(NSString *imeiStr,NSString *phoneStr,NSString *errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    //NSLog(@"--------accountID=%@",[PersonInfo sharePersonInfo].accountIDString);
    [manager POST:LOGINURL(@"getImeiPhone.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSDictionary * dic = [responseObject objectForKey:@"RESULT"];
                NSString *imeiString= [dic objectForKey:@"imei"];
                NSString *phoneString= [dic objectForKey:@"phone"];
                NSString *isThirdModel=[dic objectForKey:@"isThirdModel"];
                NSString *brandType=[dic objectForKey:@"brandType"];
                NSString *model=[dic objectForKey:@"model"];
                if ([imeiString isEqualToString:@"0"])
                {
                    imeiString = @"";
                }
                [PersonInfo sharePersonInfo].IMEIString = imeiString;
                [PersonInfo sharePersonInfo].phoneString = phoneString;
                [PersonInfo sharePersonInfo].isThirdModel=isThirdModel;
                [PersonInfo sharePersonInfo].brandType=brandType;
                [PersonInfo sharePersonInfo].model=model;
                
                [UserDefaults setObject:brandType forKey:@"brandType"];
                [UserDefaults setObject:isThirdModel forKey:@"isThirdModel"];
                [UserDefaults setObject:imeiString forKey:@"imeiString"];
                [UserDefaults synchronize];
                
                if (completed)
                {
                    completed(imeiString,phoneString,errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"",@"",errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"",@"",@"-1");
        }
    }];
}

//+27登录请求函数
+(void)LoginWithName:(NSString *)name psw:(NSString *)pswd complete:(void(^)(NSInteger  fSucceed))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"daokePassword":pswd,@"username":name,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"checkLogin.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObjectlogin:%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultStr = [responseObject objectForKey:@"RESULT"];
                
                NSString *accountIDStr = [resultStr objectForKey:@"accountID"];
                NSString *mobileStr = [resultStr objectForKey:@"mobile"];
                NSString *nameStr = [resultStr objectForKey:@"name"];
                NSString *nicknameStr = [resultStr objectForKey:@"nickname"];
                NSString *iconString = [resultStr objectForKey:@"iconString"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:accountIDStr forKey:@"accountID"];
                [defaults setObject:mobileStr forKey:@"mobile"];
                [defaults setObject:nicknameStr forKey:@"nickname"];
                [defaults setObject:nameStr forKey:@"name"];
                
                [defaults setObject:name forKey:kNameString];
                [defaults setObject:pswd forKey:kpassworldString];
                [defaults setObject:nil forKey:kFamilyPhoneOrIMEI];
                [defaults setObject:nil forKey:kAppStation];
                [defaults setObject:nil forKey:kWXUID];
                [defaults synchronize];
                
                [PersonInfo sharePersonInfo].accountIDString = accountIDStr;
                [PersonInfo sharePersonInfo].nameString = nameStr;
                [PersonInfo sharePersonInfo].nicknameString = nicknameStr;
                [PersonInfo sharePersonInfo].iconString = iconString;
                [PersonInfo sharePersonInfo].senderUserHeadName = iconString;
                
                if (completed)
                {
                    completed(0);
                }
            }
            else if([errorcode isEqualToString:@"ME18063"])
            {
                if (completed) {
                    completed(1);
                }
            }
            else if([errorcode isEqualToString:@"ME18061"])
            {
                if (completed) {
                    completed(2);
                }
            }
            else
            {
                if (completed) {
                    completed(3);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (completed) {
            completed(3);
        }
    }];
    
}


//////+28注册
+(void)registerWithPhoneNumber:(NSString *)phone times:(NSString *)times complete:(void(^)(NSString * errorCode, NSString * regCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"mobile":phone};
    [manager POST:LOGINURL(@"v3/toReg.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode,[responseObject objectForKey:@"RESULT"]);
                }
            }
            else if ([errorcode isEqualToString:@"ME18002"])
            {
                if (completed)
                {
                    completed(errorcode,@"主人,该手机号已经注册过了,可以直接去登录哦");
                }
            }
            else if([errorcode isEqualToString:@"ME01023"])
            {
                if (completed)
                {
                    completed(errorcode,@"主人,你输入的手机号有误哦");
                }
            }
            else if([errorcode isEqualToString:@"ME01001"])
            {
                if (completed)
                {
                    completed(errorcode,@"主人,你验证码获取太频繁,请在一小时后重新获取吧");
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,@"主人,网络不给力啊,请检查一下网络吧");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络好像不给力啊,检查一下网络吧");
        }
    }];
}
/////+29设置个人信息完整注册
+(void)finishedRegisterWithDic:(NSDictionary *)dic complete:(void(^)(NSString * errorCode, NSString * strFinsed))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"addCustomAccount.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
        if ([errorcode isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"RESULT"] objectForKey:@"accountID"]  forKey:ZhuceAccountId];
            [PersonInfo sharePersonInfo].accountIDString = [[responseObject objectForKey:@"RESULT"] objectForKey:@"accountID"];
            if (completed)
            {
                completed(errorcode,@"注册成功");
            }
        }
        else if ([errorcode isEqualToString:@"ME18002"])
        {
            if (completed)
            {
                completed(errorcode,@"该手机号已经被注册!");
            }
        }
        else if ([errorcode isEqualToString:@"ME22007"])
        {
            if (completed)
            {
                completed(errorcode,@"验证码错误!");
            }
        }
        else if ([errorcode isEqualToString:@"ME18002"])
        {
            if (completed)
            {
                completed(errorcode,@"该用户已经存在!");
            }
        }
        else
        {
            if (completed)
            {
                completed(errorcode,@"注册失败!");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"网络错误!");
        }
    }];
}

////+32得到功能设置列表
+(void)getFunctionList:(void(^)(NSString * errorCode,NSArray * dataArray))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getSubscribeMsg.do")  parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                id aObject = [[responseObject objectForKey:@"RESULT"] objectForKey:@"list"];
                
                if ([aObject isKindOfClass:[NSArray class]])
                {
                    NSArray *array = (NSArray *)aObject;
                    if (completed)
                    {
                        completed(errorcode,array);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
///++33保存功能设置订阅
+(void)saveNewsListWithStr:(NSString *)bodayStr complete:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSString * url = [NSString stringWithFormat:@"%@?%@",LOGINURL(@"setSubscribeMsg.do"),bodayStr];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"saveNewsListWithStr:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}
////+34修改密码
+(void)updatePasswordWithOldPsw:(NSString *)oldPsw newPsw:(NSString *)newPsw complete:(void(^)(NSString * errorCode))completed
{
    NSDictionary * dic = @{@"oldPassword":oldPsw,@"newPassword":newPsw,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS"};
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"updateUserPassword.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString * result = [responseObject objectForKey:@"RESULT"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if ([result isEqualToString:@"newPassword equal oldPassword is error!"])
                {
                    if (completed)
                    {
                        completed(@"新密码不能和老密码一样!");
                    }
                }
                else if ([result isEqualToString:@"password is not matched"])
                {
                    if (completed)
                    {
                        completed(@"您的原始密码输入错误!");
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(result);
                    }
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}
////+341轨迹
+(void)updateRoutePathWithStr:(NSDictionary *)str complete:(void(^)(NSString * errorCode,NSArray * dateArray))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"getRouteList.do")  parameters:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSArray class]])
                {
                    NSArray * array = [responseObject objectForKey:@"RESULT"];
                    if (completed)
                    {
                        completed(errorcode,array);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

/////+44榜单首页接口
+(void)getList:(void(^)(NSString * errorCode,listModel *model))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"getList") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject :: %@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    listModel * model = [listModel getModelWithDic:resultDic];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:model.grade forKey:kGrade];
                    [defaults setObject:model.gradeTitle forKey:kGradeTitle];
                    [defaults synchronize];
                    [PersonInfo sharePersonInfo].gradeTitle = model.gradeTitle;
                    [PersonInfo sharePersonInfo].grade = model.grade;
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                    //NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
                    
                    NSString *imagePath = [path stringByAppendingFormat:@"/%@",@"a.data"];
                    
                    
                    BOOL isDir= NO;
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
                    
                    if (!(isDir == YES && existed == YES))
                    {
                        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    NSMutableData* data = [[NSMutableData alloc]init];
                    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archiver encodeObject:resultDic forKey:[NSString stringWithFormat:@"dicData%@",[PersonInfo sharePersonInfo].accountIDString]];
                    [archiver finishEncoding];
                    if ([data writeToFile:imagePath atomically:YES])
                    {
                        //NSLog(@"成功");
                    }
//
                    
                    if (completed)
                    {
                        completed(errorcode,model);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
////+45全国排名和本月排名接口
+(void)getRankListWithUrl:(NSString *)url complete:(void (^)(NSString *, NSString *, RankModel *, NSMutableArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(url) parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"排名 ：：\\\\\\\\\\\\\\ %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    NSMutableArray * dataArr = [NSMutableArray array];
                    NSDictionary * responseDic = [responseObject objectForKey:@"RESULT"];
                    RankModel *model = nil;
                    if ([responseDic[@"myRankInfo"] isKindOfClass:[NSDictionary class]]) {
                        model = [RankModel getModelWithDic:responseDic[@"myRankInfo"]];
                    }
                    NSString *rankRuleText = [responseDic objectForKey:@"rankRuleText"];
                    NSArray *array = nil;
                    if ([responseDic[@"rank"] isKindOfClass:[NSArray class]]) {
                        array = responseDic[@"rank"];
                    }
                    if (array.count>0)
                    {
                        for (NSDictionary * dic  in array)
                        {
                            [dataArr addObject:[RankModel getModelWithDic:dic]];
                        }
                    }
                    if (completed)
                    {
                        completed(errorcode,rankRuleText,model,dataArr);
                    }
                    //NSLog(@"++++ %ld",dataArr.count);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil,nil);
        }
    }];
    
}

#pragma mark -- 根据频道名称,号码,管理员,所在地区查询群聊频道
+(void)fetchSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"fetchSecretChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fetchSecretChannelfetchSecretChannel:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    if ([[resultDic objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                        NSArray * listArr = [resultDic objectForKey:@"list"];
                        if (listArr.count>0)
                        {
                            NSMutableArray * dataArr = [[NSMutableArray alloc]init];
                            for (NSDictionary * infoDic in listArr)
                            {
                                [dataArr addObject:[NewChannelModel getModelWithDic:infoDic]];
                            }
                            if (completed)
                            {
                                completed(errorcode,dataArr,resultDic);
                            }
                        }
                        else{
                            if (completed)
                            {
                                completed(errorcode,nil,resultDic);
                            }
                        }
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}
////+28 得到群聊频道详情
+(void)getSecretChannelInfoWithChannelNumber:(NSString *)channelNumber completed:(void(^)(NSString * errorCode,NewChannelModel * model))completed
{
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNumber};
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"getSecretChannelInfo") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject :: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSArray class]])
                {
                    NSDictionary * dic = [[responseObject objectForKey:@"RESULT"]objectAtIndex:0];
                    NewChannelModel * model = [NewChannelModel getModelWithDic:dic];
                    if (completed)
                    {
                        completed(errorcode,model);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
/////+29 申请加入群聊频道
+(void)joinSecretChannelWithCode:(NSString *)uniqueCode completed:(void(^)(NSString * errorCode,NSString *isVerify,NSString * applyIdx))completed
{
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"uniqueCode":uniqueCode};
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"joinSecretChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"+++%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSString * isVerify = [[responseObject objectForKey:@"RESULT"]objectForKey:@"isVerify"];
                NSString * appleyIdx = [[responseObject objectForKey:@"RESULT"]objectForKey:@"applyIdx"];
                if (completed)
                {
                    completed(errorcode,isVerify,appleyIdx);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}
/////+30 用户退出群聊频道
+(void)quitSecretChannelWithNumber:(NSString *)channelNumber channelName:(NSString *)channelName completed:(void(^)(NSString * errorCode))completed
{
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNumber,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"channelName":channelName};
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"quitSecretChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"退出群聊频道的%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            //NSLog(@"+++ %@",[responseObject objectForKey:@"RESULT"]);
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

#pragma mark --查询我关注的主播频道列表--
+(void)getUserFollowListMicroChannel:(NSInteger)startPage pageCount:(NSInteger)pageCount completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dataDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"startPage":[NSString stringWithFormat:@"%ld",(long)startPage],@"pageCount":[NSString stringWithFormat:@"%ld",(long)pageCount]};
    [manager POST:LOGINURL(@"getUserFollowListMicroChannel") parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"查询我关注的主播频道列表 :: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    NSArray * resultArr = [resultDic objectForKey:@"list"];
                    if (resultArr.count>0)
                    {
                        NSMutableArray * dataArr = [NSMutableArray array];
                        for (NSDictionary * dic in resultArr)
                        {
                            [dataArr addObject:[NewChannelModel getModelWithDic:dic]];
                        }
                        if (completed)
                        {
                            completed(errorcode,dataArr);
                        }
                    }
                    else
                    {
                        if (completed)
                        {
                            completed(errorcode,nil);
                        }
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
///+4获取频道类别列表
+(void)getCatalogInfoWithType:(NSString *)channelType startPg:(NSInteger)startPg pageSize:(NSInteger)pageSize completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dataDic = @{@"appKey":@"iOS",@"startPage":[NSString stringWithFormat:@"%ld",(long)startPg],@"pageCount":[NSString stringWithFormat:@"%ld",(long)pageSize],@"channelType":channelType};
    [manager POST:LOGINURL(@"getCatalogInfoV2") parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"频道类别%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                if ([resultDic isKindOfClass:[NSDictionary class]])
                {
                    NSArray * resultArr = [resultDic objectForKey:@"list"];
                    if (resultArr.count>0) {
                        NSMutableArray * dataArr = [NSMutableArray array];
                        for (NSDictionary * dic in resultArr) {
                            [dataArr addObject:[NewChannelModel getModelWithDic:dic]];
                        }
                        if (completed) {
                            completed(errorcode,dataArr,resultDic);
                        }
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
} 
+(void)uploadImageWithImage:(UIImage *)inage imageType:(NSString *)opertaionType channel:(NewChannelModel *)model completed:(void(^)(NSString * errorCode,NSDictionary *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSString * cityCodeStr = [NSString stringWithFormat:@"%@",model.channelCityCode];
    NSString *catalogIdStr = [NSString stringWithFormat:@"%@",model.channelCatalogID];
    NSDictionary * dateDic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString  ,@"appKey":@"iOS",@"channelName": model.channelName, @"channelIntroduction": model.introduction, @"channelCityCode": cityCodeStr,@"channelCatalogID": catalogIdStr,@"openType": model.openType,@"isVerity": model.isVerity, @"channelKeyWords": model.channelKeyWords,@"file":@""};
    NSLog(@"dateDicdateDic:%@",dateDic);
    [manager POST:LOGINURL(@"applySecretChannel")  parameters:dateDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(inage, 0.5) name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObjectcreatecreatecreate :: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *resultDic = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultDic);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"___ %@",error);
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
+(void)uploadImageWithImage:(UIImage *)image completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"uploadHeadImage")  parameters:dateDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString * result = [[responseObject objectForKey:@"RESULT"] objectForKey:@"headImageUrl"];
            [defaults setObject:result forKey:@"senderUserHeadName"];
            [PersonInfo sharePersonInfo].senderUserHeadName = result;
            [defaults setObject:result forKey:MYSELF_HEAD_IMAGE_KEY];
            [defaults synchronize];
            if (completed)
            {
                completed(errorcode,result);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
/////+38退出频道,取消关注
+(void)followMicroChannelWithChannelNum:(NSString *)channelNumber uniqueCode:(NSString *)uniqueCode type:(NSString *)followType completed:(void(^)(NSString * errorCode))completed
{
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS",@"channelNumber":channelNumber,@"uniqueCode":uniqueCode,@"followType":followType};
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"followMicroChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"关注取消关注 ：：%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}
#pragma mark --获取群聊频道的用户列表--
+(void)getUserJoinListWithChannelNum:(NSString *)channelNum type:(NSString *)infoType starPage:(NSString *)startPage completed:(void(^)(NSString * errorCode,NSMutableArray * dataArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary *dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNum,@"infoType":infoType,@"startPage":startPage,@"pageCount":@"20"};
    [manager POST:LOGINURL(@"getUserJoinListSecretChannel") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"群聊频道 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    if ([[resultDic objectForKey:@"list"]isKindOfClass:[NSArray class]])
                    {
                        NSArray * array = [resultDic objectForKey:@"list"];
                        NSMutableArray * dataArr = [NSMutableArray array];
                        if (array.count>0)
                        {
                            for (NSDictionary * dic in array)
                            {
                                [dataArr addObject:[NewChannelModel getModelWithDic:dic]];
                            }
                            if (completed)
                            {
                                completed(errorcode,dataArr);
                            }
                        }
                        else
                        {
                            if (completed)
                            {
                                completed(errorcode,nil);
                            }
                        }
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}


#pragma mark - 获得主播频道列表
+ (void)getAnchorList:(NSDictionary *) dict completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *resultDict))completed{
    
    //fetchMicroChannelV2
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"v2/fetchMicroChannel") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    if ([[resultDic objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                        NSArray * listArr = [resultDic objectForKey:@"list"];
                        if (listArr.count>0)
                        {
                            NSMutableArray * dataArr = [[NSMutableArray alloc]init];
                            for (NSDictionary * infoDic in listArr)
                            {
                                [dataArr addObject:[NewChannelModel getModelWithDic:infoDic]];
                            }
                            if (completed)
                            {
                                completed(errorcode,dataArr,resultDic);
                            }
                        }
                        else{
                            if (completed)
                            {
                                completed(errorcode,nil,nil);
                            }
                        }
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}

////59 好友设置
+ (void) friendsSetting:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed{
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"friendSetting") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject::  %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}



///添加好友
+ (void) addFriends:(NSDictionary *)dict completed:(void(^)(NSString * errorCode,NSString *result))completed{
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"addFriend") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"添加好友%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode,[responseObject objectForKey:@"RESULT"]);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,[responseObject objectForKey:@"RESULT"]);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (completed){
            
            completed(@"-1",nil);
            
        }
        
    }];
}
//根据频道编码获取主播频道详情信息
+ (void)getDetailsOfChannelInfors:(NSString *)channelNumber completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dict = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS",@"channelNumber":channelNumber};
    [manager POST:LOGINURL(@"getMicroChannelInfo") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"主播详情 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSArray * resultArr = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultArr);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed){
            completed(@"-1",nil);
            
        }
    }];
}

#pragma mark --根据通讯录判断是否是微密用户--

+(void)judgeIsWeMeAccountWithMobiles:(NSMutableArray *)mobilesArr completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSMutableString * str = [NSMutableString stringWithFormat:@"accountID=%@&appKey=iOS&",[PersonInfo sharePersonInfo].accountIDString];
    for (int i = 0; i<mobilesArr.count; i++)
    {
        TKAddressBook * book = [mobilesArr objectAtIndex:i];
        NSString * mobiles = book.tel;
        if ([mobiles rangeOfString:@"-"].location != NSNotFound)
        {
            if (mobiles.length>8&&mobiles.length<13)
            {
                NSArray * arary = [mobiles componentsSeparatedByString:@"-"];
                NSString * phoneStr = [NSString stringWithFormat:@"%@%@",[arary objectAtIndex:0],[arary objectAtIndex:1]];
                if (i == mobilesArr.count-1)
                {
                    [str appendString:[NSString stringWithFormat:@"mobiles=%@",phoneStr]];
                }
                else
                {
                    [str appendString:[NSString stringWithFormat:@"mobiles=%@&",phoneStr]];
                }
                
            }
            else if (mobiles.length == 13&&[mobiles hasPrefix:@"1"])
            {
                NSArray * arary = [mobiles componentsSeparatedByString:@"-"];
                NSString * phoneStr = [NSString stringWithFormat:@"%@%@%@",[arary objectAtIndex:0],[arary objectAtIndex:1],[arary objectAtIndex:2]];
                if (i == mobilesArr.count-1)
                {
                    [str appendString:[NSString stringWithFormat:@"mobiles=%@",phoneStr]];
                }
                else
                {
                    [str appendString:[NSString stringWithFormat:@"mobiles=%@&",phoneStr]];
                }
            }
            
        }
        else
        {
            if (i == mobilesArr.count-1)
            {
                [str appendString:[NSString stringWithFormat:@"mobiles=%@",mobiles]];
            }
            else
            {
                [str appendString:[NSString stringWithFormat:@"mobiles=%@&",mobiles]];
            }
        }
    }
    NSString * url = [NSString stringWithFormat:@"judgeIsWeMeAccount?%@",str];
    if ([url rangeOfString:@" "].location != NSNotFound)
    {
        NSArray * arary = [url componentsSeparatedByString:@" "];
        url = [arary componentsJoinedByString:@""];
    }
    NSArray *array = [url componentsSeparatedByString:@"+86"];
    if(array.count>0)
    {
        url = [array componentsJoinedByString:@""];
    }
    array = [url componentsSeparatedByString:@"("];
    if(array.count>0)
    {
        url = [array componentsJoinedByString:@""];
    }
    array = [url componentsSeparatedByString:@")"];
    if(array.count>0)
    {
        url = [array componentsJoinedByString:@""];
    }
    array = [url componentsSeparatedByString:@"+"];
    if(array.count>0)
    {
        url = [array componentsJoinedByString:@""];
    }
    array = [url componentsSeparatedByString:@" "];
    if(array.count>0)
    {
        url = [array componentsJoinedByString:@""];
    }
    [manager GET:LOGINURL(url) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject :: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSArray class]])
                {
                    NSArray * resultArr = [responseObject objectForKey:@"RESULT"];
                    if (resultArr.count>0)
                    {
                        NSMutableArray * dataArr = [NSMutableArray array];
                        for (NSDictionary * dic in resultArr) {
                            [dataArr addObject: [NewChannelModel getModelWithDic:dic]];
                        }
                        if (completed)
                        {
                            completed(errorcode,dataArr);
                        }
                    }
                    else
                    {
                        if (completed)
                        {
                            completed(errorcode,nil);
                        }
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(errorcode,nil);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
        //NSLog(@"error == %@",error);
    }];
}

//44主播查询本频道所有关注用户列表
+ (void)getBossFollowListMicroChannel:(NSString *)channelNumber startPage:(NSString *)startPage pageCount:(NSString *)pageCount completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNumber,@"startPage":startPage,@"pageCount":pageCount};
    [manager POST:LOGINURL(@"getBossFollowListMicroChannelV2") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject == %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

#pragma mark --获取我的好友--
+(void)queryUserFriendWithstartPage:(NSString *)startPage pageCount:(NSString *)pageCount completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dict = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"startPage":startPage,@"pageCount":pageCount};
    [manager POST:LOGINURL(@"queryUserFriend") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"我的好友 :: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSArray * resultArr = [[responseObject objectForKey:@"RESULT"] objectForKey:@"records"];
                    if (resultArr.count>0)
                    {
                        NSMutableArray * array = [[NSMutableArray alloc]init];
                        for (NSDictionary * dic in resultArr)
                        {
                            [array addObject:[NewChannelModel getModelWithDic:dic]];
                        }
                        if (completed)
                        {
                            completed(errorcode,array);
                        }
                    }
                    else
                    {
                        if (completed)
                        {
                            completed(errorcode,nil);
                        }
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(errorcode,nil);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
//榜单配置页面
+ (void)getRankCofig:(void (^)(NSString *, NSArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"rankCofig") parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"榜单配置页面：：\\\\\\\\\\\\\\ %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"]) {
                if ([responseObject[@"RESULT"] isKindOfClass:[NSArray class]]) {
                    NSArray *rankCofigArray = responseObject[@"RESULT"];
                    if (completed) {
                        completed(errorcode,rankCofigArray);
                    }
                }
            }else{
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//指数榜单详情
+(void)getUserRankInfoWithRankType:(NSString *)rankType complete:(void (^)(NSString *, NSString *, RankModel *, NSMutableArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"rankType":rankType};
    [manager POST:LOGINURL(@"getUserRankInfo") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    NSMutableArray * dataArr = [NSMutableArray array];
                    NSDictionary * responseDic = [responseObject objectForKey:@"RESULT"];
                    RankModel *model = nil;
                    if ([responseDic[@"myRankInfo"] isKindOfClass:[NSDictionary class]]) {
                        model = [RankModel getModelWithDic:responseDic[@"myRankInfo"]];
                    }
                    NSString *rankRuleText = [responseDic objectForKey:@"rankRuleText"];
                    NSArray *array = nil;
                    if ([responseDic[@"rank"] isKindOfClass:[NSArray class]]) {
                        array = responseDic[@"rank"];
                    }
                    if (array.count>0)
                    {
                        for (NSDictionary * dic  in array)
                        {
                            [dataArr addObject:[RankModel getModelWithDic:dic]];
                        }
                    }
                    if (completed)
                    {
                        completed(errorcode,rankRuleText,model,dataArr);
                    }
                    //NSLog(@"++++ %ld",dataArr.count);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil,nil);
                    Alert([responseObject objectForKey:@"RESULT"]);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil,nil);
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
        }
    }];
}

////60 聊天推送
+(void)talkPushMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))complet
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"talkPushMessage") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"聊天推送::%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (complet)
            {
                complet(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complet)
        {
            complet(@"-1");
        }
    }];
}

//谢尔值详情页面
+(void)getUserTaskInfoWithtaskInfoType:(NSString *)taskInfoType complete:(void (^)(NSString *,NSString *, NSArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"taskInfoType":taskInfoType};
    [manager POST:LOGINURL(@"getUserTaskInfo") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"谢尔值详情 ：：\\\\\\\\\\\\\\ %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    NSArray * dataArr = nil;
                    NSDictionary * responseDic = [responseObject objectForKey:@"RESULT"];
                    NSString *resultInfo = nil;
                    if (![responseDic[@"resultInfo"] isEqualToString:@""]) {
                        resultInfo = responseDic[@"resultInfo"];
                    }
                    if ([responseDic[@"taskInfo"] isKindOfClass:[NSArray class]]) {
                        dataArr = responseDic[@"taskInfo"];
                    }
                    
                    if (completed)
                    {
                        completed(errorcode,resultInfo,dataArr);
                    }
                    //NSLog(@"++++ %ld",dataArr.count);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}
///user/v1.0/mobileRewardRochelle  领取谢尔值 64
+(void)getRochelleWithRewardID:(NSString *)rewardID completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"rewardID":rewardID};
    [manager POST:LOGINURL(@"/user/v1.0/mobileRewardRochelle") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"领取谢尔值 ：：\\\\\\\\\\\\\\ %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
    
}


//全部排名

+ (void)getRankListInfoByShellWithUrl:(NSString *)url complete:(void (^)(NSString *, NSArray *, NSDictionary *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(url) parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"排名 ：：\\\\\\\\\\\\\\ %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    NSMutableArray * dataArr = [NSMutableArray array];
                    NSDictionary * responseDic = [responseObject objectForKey:@"RESULT"];
                    NSDictionary * myRankInfo = nil;
                    if ([responseDic[@"myRankInfo"] isKindOfClass:[NSDictionary class]]) {
                        myRankInfo = responseDic[@"myRankInfo"];
                    }
                    NSArray *array = nil;
                    if ([responseDic[@"rank"] isKindOfClass:[NSArray class]]) {
                        array = responseDic[@"rank"];
                    }
                    if (array.count>0)
                    {
                        for (NSDictionary * dic  in array)
                        {
                            [dataArr addObject:[RankModel getModelWithDic:dic]];
                        }
                    }
                    if (completed)
                    {
                        completed(errorcode,dataArr,myRankInfo);
                    }
                    //NSLog(@"++++ %ld",dataArr.count);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}
//73 获取用户去过的城市
+ (void)getArriveCity:(void (^)(NSString *, NSArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getArriveCity") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"去过的城市 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSArray *ary = nil;
            if ([responseObject[@"RESULT"] isKindOfClass:[NSArray class]]) {
                ary = responseObject[@"RESULT"];
            }
            if (completed)
            {
                completed(errorcode,ary);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//去过的城市for web
+ (void)getArriveCityForWebView:(void (^)(NSDictionary *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString/*@"fmJFTllp6R"*/};
    [manager POST:LOGINURL(@"getArriveCity") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"去过的城市 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if (completed)
            {
                completed(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(nil);
        }
    }];
}

////去过的城市for web
//+ (void)getArriveCityForWebView:(void (^)(NSDictionary *))completed
//{
//    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
//#warning
//    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString/*@"fmJFTllp6R"*/};
//    [manager POST:LOGINURL(@"getArriveCity") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"去过的城市 %@",responseObject);
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
//            NSArray *ary = nil;
//            if ([responseObject[@"RESULT"] isKindOfClass:[NSArray class]]) {
//                ary = responseObject[@"RESULT"];
//            }
//            if (completed)
//            {
//                completed(responseObject);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (completed)
//        {
//            completed(nil);
//        }
//    }];
//}

//去过的热点 for web
+ (void)getHotPointForWebView:(void (^)(NSString *,NSDictionary *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getHotPoint") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"去过的热点 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
//            NSArray *ary = nil;
//            if ([responseObject[@"RESULT"] isKindOfClass:[NSDictionary class]]) {
//                ary = responseObject[@"RESULT"];
//            }
            
            if (completed)
            {
                completed(errorcode,responseObject[@"RESULT"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//去过的里程 日历
+ (void)getSumMileageListWithBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate complete:(void (^)(NSString *, NSArray *, NSArray *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"startTime":beginDate,@"endTime":endDate};
    [manager POST:LOGINURL(@"getSumMileageList.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"responseObject :: %@",responseObject);
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * responseDic = [responseObject objectForKey:@"RESULT"];
                    NSArray * dateTimeAry = nil;
                    if ([responseDic[@"dateTime"] isKindOfClass:[NSArray class]]) {
                        dateTimeAry = responseDic[@"dateTime"];
                    }
                    NSArray * sumMileageAry = nil;
                    if ([responseDic[@"sumMileage"] isKindOfClass:[NSArray class]]) {
                        sumMileageAry = responseDic[@"sumMileage"];
                    }
                    if (completed)
                    {
                        completed(errorcode,dateTimeAry,sumMileageAry);
                    }
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil);
        }
    }];
}

#pragma mark --举报
+(void)insertTeportInfoWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"insertReportInfo") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"举报 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

#pragma mark --删除好友--
+(void)removeUserFriendWithFriendAccountId:(NSString *)accountId completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSString * url = [NSString stringWithFormat:@"%@?accountID=%@&friendAccountID=%@",LOGINURL(@"removeUserFriend"),[PersonInfo sharePersonInfo].accountIDString,accountId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"删除好友 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

//注册 个人信息
+ (void)uploadUserInforWith:(NSString *)nickname areaCode:(NSString *)areaCode gender:(NSString *)gender completed:(void(^)(NSString * errorCode, NSString * resultStr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSString *accountID = [PersonInfo sharePersonInfo].accountIDString;
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":accountID,@"gender":gender,@"areaCode":areaCode,@"nickname":nickname};
    [manager POST:LOGINURL(@"fixUserInfo.do") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject == %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *resultStr = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultStr);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

#pragma mark - 我的消息
+ (void)getPushMessage:(NSDictionary *)dict completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed{
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"queryMessageCentre") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"消息推送::%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    NSMutableArray * array = [resultDic objectForKey:@"records"];
                    if (completed)
                    {
                        // 这里的代码会在主线程执行
                        completed(errorcode,array);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
//77.找回密码发送验证码
+ (void)sendIdentifyingCodeMobilePhone:(NSString *)mobile times:(NSString *)times completed:(void(^)(NSString * errorCode, NSString * resultStr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"mobile":mobile,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"v2/sendIdentifyingCode") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *resultStr = [responseObject objectForKey:@"RESULT"];
            //NSLog(@"%@",resultStr);
            if (completed)
            {
                completed(errorcode,resultStr);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"获取失败!");
        }
    }];
}
////36.设置用户按键自定义接口
+ (void)setUserkeyInfo:(NSDictionary *)parameter completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"parameter":parameter};
    [manager POST:LOGINURL(@"setUserkeyInfo") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"设置用户按键自定义接口 responseObject == %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}


///56.同意添加好友
+ (void) agreeAddFriend:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"agreeAddFriend") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                //                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                //                {
                NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                //                    if (completed)
                //                    {
                // 这里的代码会在主线程执行
                completed(errorcode,resultDic);
                //                    }
                //                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
    
    
    
}

////57.不同意添加好友

//37.设置一个用户按键自定义
+ (void)setOnlyOneUserkeyInfocustomType:(NSString *)remark actionType:(NSString *)actionType customParameter:(NSString *)uniqueCode completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"remark":remark,@"actionType":actionType,@"uniqueCode":uniqueCode};
    //joinSecretChannel
    //LOGINURL(@"secretChannelJoinSetkey")
    [manager POST:LOGINURL(@"secretChannelJoinSetkey") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
               
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);

                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

+(void)applyJoinChannel:(NSString *)remark actionType:(NSString *)actionType customParameter:(NSString *)uniqueCode completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"remark":remark,@"actionType":actionType,@"uniqueCode":uniqueCode};
    //joinSecretChannel
    //LOGINURL(@"secretChannelJoinSetkey")
    [manager POST:LOGINURL(@"joinSecretChannel") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
                
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];


}

+ (void) noAgreeAddFriend:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"disAgreeAddFriend") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                //                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                //                {
                NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                if (completed)
                {
                    // 这里的代码会在主线程执行
                    completed(errorcode,resultDic);
                }
                //                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
    
    
}

//标记已读消息
+ (void) markReadMessage:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    
    
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"updateMessageIsRead") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                //                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                //                {
                NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                if (completed)
                {
                    // 这里的代码会在主线程执行
                    completed(errorcode,resultDic);
                }
                //                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
///35.获取用户按键自定义接口
+ (void)getUserkeyInfo:(NSString *)actionType Completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dateDic = @{@"appKey":@"iOS",@"actionType":actionType,
                              @"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getUserkeyInfo") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
#pragma mark --申请加入群聊频道验证推送--
+(void)pushJoinSecretChannelMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"pushJoinSecretChannelMessage") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@" 加入频道的验证 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}
///78.手机用户根据验证码重置新密码请求
+ (void)resetPasswordCheckVerifyCodeWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword completed:(void(^)(NSString * errorCode, NSString * resultStr))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dateDic = @{@"mobile":mobile,@"appKey":@"iOS",@"verifyCode":verifyCode,@"newPassword":newPassword};
    [manager POST:LOGINURL(@"v2/resetPasswordCheckVerifyCode") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *ersultStr = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,ersultStr);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}


#pragma mark-- ..群聊频道消息提醒
+(void)secretChannelMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"secretChannelMessage") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"群聊频道消息提醒 %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}


#pragma mark --解散频道--
+(void)dissolveSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"dissolveSecretChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"解散频道 %@",responseObject);
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        if (completed)
        {
            completed(errorcode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

#pragma mark -- 转移频道

+(void)transferSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"transferSecretChannel") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"转移频道 %@",responseObject);
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        if (completed)
        {
            completed(errorcode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

#pragma mark - 同意或拒绝加入频道

#pragma mark --更多--
+(void)getMoreListWithDic:(NSDictionary *)dic comple:(void(^)(NSString * errorCode,NSMutableArray *dataArr,NSMutableArray *adArray,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"v2/getMoreList") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"更多接口 %@",responseObject);
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
                    NSMutableArray *dataArr = [NSMutableArray array];
                    NSMutableArray *adArray = [[NSMutableArray alloc]init];
                    //获取头部广告轮播图片数组
                    if ([[resultDic objectForKey:@"ad"]isKindOfClass:[NSArray class]])
                    {
                        NSArray *adArr = [resultDic objectForKey:@"ad"];
                        if (adArr.count>0)
                        {
                            for (NSDictionary * dics in adArr)
                            {
                                [adArray addObject:[MoreModely getModelWithDic:dics]];
                            }
                        }
                    }
                    //获取列表显示数组
                    if ([[resultDic objectForKey:@"appList"]isKindOfClass:[NSArray class]])
                    {
                        NSArray * applistArr = [resultDic objectForKey:@"appList"];
                        if (applistArr.count>0)
                        {
                            for (NSDictionary * dics in applistArr)
                            {
                                [dataArr addObject:[MoreModely getModelWithDic:dics]];
                            }
                        }
                    }
                    if (completed)
                    {
                        completed(errorcode,dataArr,adArray,resultDic);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil,nil,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil,nil,nil);
        }
    }];
}

#pragma mark - 同意或拒绝加入频道

+ (void) agreeOrRefuseJoinChannel:(NSDictionary *)dict completed:(void(^)(NSString * errorCode))completed{

    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"veritySecretChannelMessage") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        NSString *result = [responseObject objectForKey:@"RESULT"];
        if ([result isEqualToString:@"message is dealed"]) {
            Alert(@"主人,此消息已处理了哟");
            completed(errorcode);
            return;
        }
        //NSLog(@"errorcode %@",errorcode);
        if (completed)
        {
            completed(errorcode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

///更改地区
+ (void)fixUserInfo:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"fixUserInfo") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        //NSString *result = [responseObject objectForKey:@"RESULT"];
        if (completed)
        {
            completed(errorcode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}


#pragma mark - 清空消息中心
+ (void) clearMessageCenter:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"removeMessageCentre") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        //        NSString *result = [responseObject objectForKey:@"RESULT"];
        //NSLog(@"errorcode %@",errorcode);
        if (completed)
        {
            completed(errorcode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];

}


#pragma mark - 查询有多少未读消息
+ (void) selectMessageCount:(NSDictionary *) dict  completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"countNewMessageCentre") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
        //        NSString *result = [responseObject objectForKey:@"RESULT"];
        //NSLog(@"errorcode %@",errorcode);
        if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];

            if (completed)
            {
                completed(errorcode,resultDic);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}



#pragma  mark --创建者修改群聊频道详情--
+(void)modifySecretChannelInfoWithDic:(NSDictionary *)dic image:(UIImage *)image completed:(void(^)(NSString * errorCode))completed
{
    NSData * imageData = nil;
    if (image)
    {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"modifySecretChannelInfo")  parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData!=nil)
        {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename.jpeg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"创建者修改群聊频道详情 %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if (completed)
            {
                completed(errorcode);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1");
        }
    }];
}

//88 足迹分享图片
+(void)uploadFootmarkShareWithImage:(UIImage *)image completed:(void(^)(NSString * errorCode,NSString *url))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDictionary * dateDic = @{@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"uploadFootmarkShare")  parameters:dateDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString * result = [responseObject objectForKey:@"RESULT"];
            
//            [defaults setObject:result forKey:@"senderUserHeadName"];
//            [PersonInfo sharePersonInfo].senderUserHeadName = result;
//            [defaults setObject:result forKey:MYSELF_HEAD_IMAGE_KEY];
//            [defaults synchronize];
            if ([errorcode isEqualToString:@"0"]) {
                if (completed)
                {
                    completed(errorcode,result);
                }
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
//76.查询用户好友设置
+ (void)queryFriendSettingcompleted:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dateDic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"queryFriendSetting") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary * resultDic = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultDic);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
#pragma mark - 查询道客钱包页面
+(void)queryDaoKeWallet:(void(^)(NSString * errorCode,NSMutableArray * dataArray))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dateDic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager GET:LOGINURL(@"mall/queryDaokeWallet") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
             NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"]isKindOfClass:[NSArray class]])
                {
                    NSArray * resultArr = [responseObject objectForKey:@"RESULT"];
                    NSMutableArray * dataArr = [NSMutableArray array];
                    for (NSDictionary * dic in resultArr)
                    {
                        MoneyModely *model = [[MoneyModely alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        model.mid = [dic objectForKey:@"id"];
                        [dataArr addObject:model];
                    }
                    if (completed)
                    {
                        completed(errorcode,dataArr);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

+ (void)getLocation:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dic = @{@"appKey":@"ios",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getLocation") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if ([[responseObject objectForKey:@"RESULT"] isKindOfClass:[NSDictionary class]])
                {
                    if (completed)
                    {
                        completed(errorcode,responseObject[@"RESULT"]);
                    }
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
        
    }];
}
//微信登录绑定手机号输入密码
+ (void)verifyAndresetWithMobile:(NSString *)mobile verificationCode:(NSString *)verificationCode newPassword:(NSString *)newPassword completed:(void(^)(NSString * errorCode, NSString * resultStr))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dic = @{@"newmobile":mobile,@"validateCode":verificationCode,@"newPassword":newPassword,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS",@"mobile":@""};
            NSLog(@"dic:%@",dic);
    NSLog(@"dicdicdicdicdicdic:%@",dic);
    [manager POST:LOGINURL(@"userBindMobile") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {

//        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            //NSString *resultCode = [responseObject objectForKey:@"RESULT"];
            NSString *resultStr = nil;
            if([errorcode isEqualToString:@"0"])
            {
                resultStr = @"主人,密码不正确哦";
            }
            else if([errorcode isEqualToString:@"ME18063"])
            {
                resultStr = @"主人,密码不正确哦";
            }
            else if([errorcode isEqualToString:@"ME22007"])
            {
                resultStr = @"主人,验证码已经失效了哦";
            }
            if (completed)
            {
                completed(errorcode,resultStr);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (completed)
        {
            completed(@"-1",@"主人,网络好像不给力啊,检查一下网络吧");
        }

    }];
}
//获取用户信息
+ (void)getUserInfo:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"appKey":@"iOS"};
    NSString *fullPath = [self filePath:@"getUserInfo"];
    [manager POST:LOGINURL(@"getUserInfo.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            [responseObject writeToFile:fullPath atomically:YES];
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *resultDic = [responseObject objectForKey:@"RESULT"];
            if([errorcode isEqualToString:@"0"])
            {
                //
            }
            if (completed)
            {
                completed(errorcode,resultDic);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *errorcode = [dic objectForKey:@"ERRORCODE"];
        if ([errorcode isEqualToString:@"0"])
        {
            NSDictionary *resultDic = [dic objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultDic);
            }
        }
        else
        {
            //从本地读取信息失败
            if (completed)
            {
                completed(@"-1",nil);
            }
        }
    }];
}

#pragma mark - 把文件存到本地
+ (NSString *)filePath:(NSString *)fileName
{
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/DataCache"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:homePath])
    {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(fileName && fileName.length !=0)
    {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    return homePath;
}
#pragma mark - 微密换货
+ (void)applyExchangeGoods:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany name:(NSString *)name telephone:(NSString *)telephone address:(NSString *)address exchangeReason:(NSString *)exchangeReason completed:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed
{
    NSDictionary *dic = @{@"expressNumber":expressNumber,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"expressCompany":expressCompany,@"depositPassword":@"",@"appKey":@"iOS",@"address":address,@"name":name,@"telephone":telephone,@"exchangeReason":exchangeReason};
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    [manager POST:LOGINURL(@"applyExchangeGoods.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            //NSString *resultCode = [responseObject objectForKey:@"RESULT"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0",nil);
                }
            }else if ([errorcode isEqualToString:@"ME01023"])
            {
                if (completed)
                {
                    completed(@"1",nil);
                }
            }
            else if ([errorcode isEqualToString:@"ME18036"])
            {
                if (completed)
                {
                    completed(@"2",nil);
                }
            }else if([errorcode isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"3",nil);
                }
            }else
            {
                if (completed)
                {
                    completed(@"4",nil);
                }
            }
        }
        else
        {
            if (completed)
            {
                completed(@"5",nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"5",nil);
        }
    }];
}
//历史反押
+ (void)fetchDepositHisotry:(void (^)(NSString *errorCode, NSArray *resultArr))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dic = @{@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"fetchDepositHisotry.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray *_historyArray = [[NSMutableArray alloc]init];
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
            {
                id aObject = [dict objectForKey:@"RESULT"];
                if ([aObject isKindOfClass:[NSArray class]])
                {
                    NSArray *array = (NSArray *)aObject;
                    int aCount = (int)[array count];
                    
                    for (int i = 0; i < aCount; i++)
                    {
                        DepositHisotryInfo *info = [[DepositHisotryInfo alloc]init];
                        int amount = [[[array objectAtIndex:i]objectForKey:@"withdrawDepositAmount"] intValue];
                        
                        info.withdrawDepositAmount = [NSString stringWithFormat:@"%d",amount];
                        info.changedAmount = [[array objectAtIndex:i]objectForKey:@"changedAmount"];
                        
                        info.remark = [[array objectAtIndex:i]objectForKey:@"remark"];
                        long long int time =[[[array objectAtIndex:i]objectForKey:@"updateTime"] longLongValue];
                        info.updateTime = [NSString stringWithFormat:@"%lld",time];
                        
                        info.imeiString = [PersonInfo sharePersonInfo].IMEIString;
                        [_historyArray addObject:info];
                    }
                }
                if (completed)
                {
                    completed(@"-1",_historyArray);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
//修改押金密码
+ (void)updateDepositPasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completed:(void (^)(NSString *errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dict = @{@"oldPassword":oldPassword,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"newPassword":newPassword,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"updateDepositPassword.do") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([[responseObject objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0");
                }
            }
            else if ([[responseObject objectForKey:@"ERRORCODE"] isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"1");
                }
            }
        }
        else
        {
            if (completed)
            {
                completed(@"3");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"3");
        }
    }];
}

//退货解约
+ (void)applyCancelContractWithDepositPassword:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany completed:(void (^)(NSString *errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dict = @{@"depositPassword":depositPassword,@"expressNumber":expressNumber,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"expressCompany":expressCompany,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"applyCancelContract.do") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            
            if ([errorStr isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0");
                }
            }
            else if ([errorStr isEqualToString:@"ME18033"])
            {
                if (completed)
                {
                    completed(@"1");
                }
            }
            else if ([errorStr isEqualToString:@"ME18034"])
            {
                if (completed)
                {
                    completed(@"2");
                }
            }
            else if ([errorStr isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"3");
                }
            }
            else if ([errorStr isEqualToString:@"ME18036"])
            {
                if (completed)
                {
                    completed(@"4");
                }
            }
            else if ([errorStr isEqualToString:@"ME18515"])
            {
                if (completed)
                {
                    completed(@"7");
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"5");
                }
            }
        }
        else
        {
            if (completed)
            {
                completed(@"6");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"6");
        }
    }];
}
//申领押金->我要转账
+ (void)applyWithdrawDepositApplyWithdrawAmount:(NSString *)applyWithdrawAmount depositPassword:(NSString *)depositPassword completed:(void (^)(NSString *errorCode))completed
{
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dict = @{@"applyWithdrawAmount":applyWithdrawAmount,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"depositPassword":depositPassword,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"applyWithdrawDeposit.do") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorStr isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0");
                }
            }else if ([errorStr isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"1");
                }
            }else if ([errorStr isEqualToString:@"ME18037"])
            {
                if (completed)
                {
                    completed(@"2");
                }
            }
            else if ([errorStr isEqualToString:@"ME18038"])
            {
                if (completed)
                {
                    completed(@"3");
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"4");
                }
            }
        }
        else
        {
            if (completed)
            {
                completed(@"4");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"4");
        }
    }];
}

//获取个人信息

+ (void)getUserDepositInfoCompleted:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed
{
    NSString *imeiStr = [PersonInfo sharePersonInfo].IMEIString;
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dict = @{@"IMEI":imeiStr,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"getUserDepositInfo.do") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorStr,resultDict);
            }
        }
        else
        {
            if (completed)
            {
                completed(@"-1",nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//微信登录 创建手机号
+ (void)wxLoginUidCreateAccountID:(NSString *)uid nickname:(NSString *)nickname completed:(void (^)(NSString *errorCode))completed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [RequestManager getManager];
    NSDictionary *dict = @{@"appKey":@"iOS",@"account":uid,@"loginType":@"5",@"nickname":nickname};
    [manager POST:LOGINURL(@"createAccountID.do") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            if([errorStr isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                NSString *accoutID = [resultDict objectForKey:@"accountID"];
                NSString *nickname = [resultDict objectForKey:@"nickname"];
                NSString *iconString = [defaults objectForKey:@"iconString"];
                
                [PersonInfo sharePersonInfo].accountIDString = accoutID;
                [PersonInfo sharePersonInfo].nicknameString = nickname;
                [PersonInfo sharePersonInfo].iconString = iconString;
                [PersonInfo sharePersonInfo].senderUserHeadName = iconString;
                
                NSString *userDefaultsPhoneString = [defaults objectForKey:@"phone"];
                //验证是否绑定手机号
                if (userDefaultsPhoneString == nil || userDefaultsPhoneString.length==0)
                {
                    if (completed)
                    {
                        completed(@"11");
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(@"0");
                    }
                }

            }
            else
            {
                if (completed)
                {
                    completed(@"2");
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"3");
        }
    }];
}

#pragma mark - 历史记录
//http://test.wemeapp.mirrtalk.com/WeMe/getUserKeyHistoryList?accountID=kxl1QuHKCD&appKey=iOS&actionType=
+(void)searchHistoryCreateAccountID:(NSString *)countID completed:(void (^)(NSString *))completed
{
    AFHTTPRequestOperationManager *manager=[RequestManager getManager];
    NSDictionary *dic=@{@"appKey":@"iOS",@"accountID":countID,@"actionType":@""};
    [manager POST:LOGINURL(@"getUserKeyHistoryList") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *paramNameArr=[NSMutableArray array];
        [paramNameArr removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorStr isEqualToString:@"0"]) {
               NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                NSArray *list=resultDict[@"list"];
                for (NSDictionary *dic in list) {
                    HistoryModel *model=[[HistoryModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                }

                if (completed) {
                    completed(@"0");
                }
            }
        }
//        [PlistHelper addsearchHistoryArray:paramNameArr];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/**
 *  置空
 *
 *  @param actionType <#actionType description#>
 */
+(void)setOnlyOneUserkeyInfoEmpty:(NSString*)actionType completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"customType":@"10",@"actionType":actionType,@"customParameter":@""};
    [manager POST:LOGINURL(@"setOnlyOneUserkeyInfo") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
    
}

+(void)setOnlyOneUserkeyInfoActionType:(NSString *)actionType customType:(NSString *)customType completed:(void (^)(NSString *, NSDictionary *))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"customType":customType,@"actionType":actionType,@"customParameter":@""};
    [manager POST:LOGINURL(@"setOnlyOneUserkeyInfo") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];

}

+(void)dismissBindTelPhone:(NSString*)telPhoneNum validateCode:(NSString*)validateCode completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"mobile":telPhoneNum,@"code":validateCode};
    [manager POST:LOGINURL(@"cancellationAccountByMobileCode") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
    
}
//获取绑定过的手机验证码
+(void)getBindPhoneNumCode:(NSString*)telPhoneNum completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    NSDictionary * dateDic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"mobile":telPhoneNum};
    //LOGINURL(@"getCancellationAccountCode")
    
    [manager POST:LOGINURL(@"getCancellationAccountCode") parameters:dateDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            
            if([errorcode isEqualToString:@"0"])
            {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                
                if (completed)
                {
                    completed(errorcode,resultDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorcode,nil);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

/**
 *  检查appstore的版本信息
 *
 *  @param completed 完成后的回调函数
 */
+(void)checkAPPStoreAppInfo:(void (^)(NSDictionary *))completed{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    [manager GET:getAppInfoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
                
                if (completed)
                {
                    completed(responseObject);
                }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(nil);
        }
    }];
}
@end