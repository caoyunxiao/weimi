//
//  Request1617.m
//  微密
//
//  Created by Daoke Dev on 15/2/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "Request1617.h"
#import "AFHTTPRequestOperationManager.h"
#import "HTTPPostRequest.h"
#import "RequestManager.h"


@implementation Request1617

+ (void)userApplyChannel:(NSString *)channelNumber channelName:(NSString *)channelName channelIntroduction:(NSString *)channelIntroduction channelCityCode:(NSString *)channelCityCode channelCatalog:(NSString *)channelCatalog  chiefAnnouncerIntr:(NSString *)chiefAnnouncerIntr image:(UIImage *)image applyBlock:(UserApplyChannelBLOCK)applyBlock
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNumber,@"channelName":channelName,@"channelIntroduction":channelIntroduction,@"channelCityCode":channelCityCode,@"channelCatalogID":channelCatalog,@"chiefAnnouncerIntr":chiefAnnouncerIntr};
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [manager POST:LOGINURL(@"applyMicroChannel") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:imageData name:@"file" fileName:@"1.png" mimeType:@"image/jpeg"];
     }
     //我的测试申请我的测试申请我的测试申请请
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = (NSDictionary *)responseObject;
             
             if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
             {
                 if (applyBlock)
                 {
                     applyBlock(0);
                 }
             }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18104"])
             {
                 if (applyBlock) {
                     applyBlock(1);
                 }
             }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18105"])
             {
                 if (applyBlock) {
                     applyBlock(2);
                 }
             }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18106"])
             {
                 if (applyBlock) {
                     applyBlock(3);
                 }
             }
             else
             {
                 if (applyBlock) {
                     applyBlock(4);
                 }
             }
         }
         else
         {
             if (applyBlock)
             {
                 applyBlock(4);
             }
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (applyBlock)
         {
             applyBlock(5);
         }
     }];
}

//WEME->密点->密点详情（道客账户）
+(void)requestDetailsOfMiDianWithMoneyType:(NSString *)moneyType complete:(void(^)(NSString * errorCode, NSDictionary * resultOfMiDian))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"moneyType":moneyType};
    [manager POST:LOGINURL(@"getUserFinanceInfo.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            
            if ([errorcode isEqualToString:@"0"])
            {
                id jsonObject = [[dataDict objectForKey:@"RESULT"] objectAtIndex:0];
                
                if ([jsonObject isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = (NSDictionary *)jsonObject;
                    
                    int moneyType = [[dic objectForKey:@"moneyType"] intValue];
                    
                    if (moneyType == 1)
                    {
                        if (completed)
                        {
                            NSDictionary *str = [[dataDict objectForKey:@"RESULT"] objectAtIndex:0];
                            completed(errorcode,str);
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

//WEME->密点->获取订单详情
+(void)requestDetailsOfOrderWithStartTime:(NSString *)startTime complete:(void(^)(NSString * errorCode, NSArray * array))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"startTime":startTime,@"moneyType":@"1"};
    [manager POST:LOGINURL(@"getBalanceDetail.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                id aObject = [dataDict objectForKey:@"RESULT"];
                
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
                    completed(@"-1",nil);
                }
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

//频道->服务->语音记事本（刷新）
+(void)getVoiceRefrushListWithPageSize:(NSString *)pageSize currentPage:(NSString *)currentPage complete:(void(^)(NSString * errorCode, NSArray * array))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"maxCount":pageSize,@"currentPage":currentPage,@"fileType":@"1"};
    [manager POST:LOGINURL(@"fetchVoiceNotepad.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                NSArray *array = [[dataDict objectForKey:@"RESULT"]objectForKey:@"list"];
                if (completed)
                {
                    completed(errorcode,array);
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"-1",nil);
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

//合约细则
+ (void)getDepositTypeInfoDepositType:(NSString *)depositType complete:(void(^)(NSString * errorCode, NSArray * dictRequest))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"appKey":@"iOS",@"IMEI":[PersonInfo sharePersonInfo].IMEIString};
    __block NSArray *depositDict;
    [manager POST:LOGINURL(@"getDepositTypeInfo.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"==============%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                depositDict =[dataDict objectForKey:@"RESULT"] ;
                if (completed)
                {
                    completed(errorcode,depositDict);
                }
            }
            else
            {
                if (completed)
                {
                    completed(@"-1",nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (completed)
         {
             completed(@"-1",nil);
         }
    }];


}
//请求个人信息
+ (void)getUserDepositInfoComplete:(void(^)(NSString * errorCode, NSDictionary * dictRequest))completed
{

}

//微密换货
+ (void)applyExchangeGoods:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany name:(NSString *)name telephone:(NSString *)telephone address:(NSString *)address exchangeReason:(NSString *)exchangeReason complete:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"expressNumber":expressNumber,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"appKey":@"iOS",@"expressCompany":expressCompany,@"depositPassword":@"",@"address":address,@"name":name,@"telephone":telephone,@"exchangeReason":exchangeReason};
    [manager POST:LOGINURL(@"applyExchangeGoods.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0");
                }
            }else if ([errorcode isEqualToString:@"ME01023"])
            {
                if (completed)
                {
                    completed(@"1");
                }
            }
            else if ([errorcode isEqualToString:@"ME18036"])
            {
                if (completed)
                {
                    completed(@"2");
                }
            }else if([errorcode isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"3");
                }
            }else
            {
                if (completed)
                {
                    completed(@"4");
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"5");
        }
    }];

}
//退货解约
+ (void)applyCancel:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany complete:(void(^)(NSString * errorCode))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"depositPassword":depositPassword,@"expressNumber":expressNumber,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"IMEI":[PersonInfo sharePersonInfo].IMEIString,@"expressCompany":expressCompany,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"applyCancelContract.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            
            NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
            if ([errorcode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(@"0");
                }
            }else if ([errorcode isEqualToString:@"ME18033"])
            {
                if (completed)
                {
                    completed(@"1");
                }
            }
            else if ([errorcode isEqualToString:@"ME18034"])
            {
                if (completed)
                {
                    completed(@"2");
                }
            }
            else if([errorcode isEqualToString:@"ME18035"])
            {
                if (completed)
                {
                    completed(@"3");
                }
            }
            else if([errorcode isEqualToString:@"ME18036"])
            {
                if (completed)
                {
                    completed(@"5");
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"6");
        }
    }];
    
}
//历史反押
+ (void)deposithHistoryComplete:(void(^)(NSString * errorCode, NSDictionary * dictRequest))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"appKey":@"iOS",@"IMEI":[PersonInfo sharePersonInfo].IMEIString};
   [manager POST:LOGINURL(@"fetchDepositHisotry.do") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if ([responseObject isKindOfClass:[NSDictionary class]])
       {
           NSDictionary *dataDict = (NSDictionary *)responseObject;
           
           NSString * errorcode = [dataDict objectForKey:@"ERRORCODE"];
           if ([errorcode isEqualToString:@"0"])
           {
               if (completed)
               {
                   completed(errorcode,dataDict);
               }
           }
           else
           {
               if (completed)
               {
                   completed(@"-1",nil);
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

//48.修改群聊频道详情
+ (void)modifySecretChannelInfoChannelNumber:(NSString *)channelNumber channelName:(NSString *)channelName channelIntro:(NSString *)channelIntro channelCitycode:(NSString *)channelCitycode channelCatalogID:(NSString *)channelCatalogID channelCatalogUrl:(NSString *)channelCatalogUrl channelOpenType:(NSString *)channelOpenType channelKeyWords:(NSString *)channelKeyWords isVerify:(NSString *)isVerify  completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = @{@"appKey":@"iOS",
                          @"accountID":[PersonInfo sharePersonInfo].accountIDString,
                          @"channelNumber":@"iOS",
                          @"channelName":channelName,
                          @"channelIntro":channelIntro,
                          @"channelCitycode":channelCitycode,
                          @"channelCatalogID":channelCatalogID,
                          @"channelCatalogUrl":channelCatalogUrl,
                          @"channelOpenType":channelOpenType,
                          @"channelKeyWords":channelKeyWords};
    [manager POST:LOGINURL(@"modifySecretChannelInfo") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"48.修改群聊频道详情 === %@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString * resultStr = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultStr);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络好像不给力啊,检查一下网络吧");
        }
    }];
}
//79.获取服务频道列表
+ (void)getServerChannel:(NSString *)startPage pageCount:(NSString *)pageCount longitude:(NSString *)longitude latitude:(NSString *)latitude  completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"startPage":startPage,@"pageCount":pageCount,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"longitude":longitude,@"latitude":latitude,};
    [manager POST:LOGINURL(@"getServerChannel") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary * resultStr = [responseObject objectForKey:@"RESULT"];
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
//80.获取服务频道菜单列表
+ (void)getServerMenuWithserverChannelID:(NSString *)serverChannelID completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"serverChannelID":serverChannelID};
    [manager POST:LOGINURL(@"getServerMenu") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSArray * resultArr = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultArr);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}
//81.获取服务频道消息列表
+ (void)getServerChannel:(NSString *)startPage pageCount:(NSString *)pageCount serverChannelID:(NSString *)serverChannelID completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"startPage":startPage,
                           @"pageCount":pageCount,
                           @"serverChannelID":serverChannelID};
    [manager POST:LOGINURL(@"queryServerChannelMessage") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString * errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary * resultDict = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,resultDict);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//48.修改群聊频道详情
+ (void)modifySecretChannelInfo:(NSString *)channelNumber ChannelOpenType:(NSString *)channelOpenType isVerify:(NSString *)isVerify completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",
                           @"accountID":[PersonInfo sharePersonInfo].accountIDString,
                           @"channelNumber":channelNumber,
                           @"channelOpenType":channelOpenType,
                           @"channelIsVerify":isVerify};
    [manager POST:LOGINURL(@"modifySecretChannelInfo") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorcode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorcode,result);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
    
}
//禁言或者拉黑
+ (void)manageSecretChannelUsersWithSign:(NSString *)sign infoType:(NSString *)infoType channelNumber:(NSString *)channelNumber curStatus:(NSString *)curStatus userAccountID:(NSString *)userAccountID completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"sign":@"",@"infoType":infoType,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":channelNumber,@"curStatus":curStatus,@"userAccountID":userAccountID};
    [manager POST:LOGINURL(@"manageSecretChannelUsers") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorCode,result);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}
//绑定手机号 - 发送验证码
+ (void)sendBindVerifyMessage:(NSString *)mobile times:(NSString *)times completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"mobile":mobile,@"appKey":@"iOS"};
    [manager POST:LOGINURL(@"v2/sendBindVerifyMessage") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *result = [responseObject objectForKey:@"RESULT"];
            if([errorCode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorCode,result);
                }
            }
            else
            {
//                if (completed)
//                {
                    completed(errorCode,@"主人,请求失败哦");
//                }
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络不给力啊,请检查一下网络吧");
        }

    }];
}

//判断手机号是否被注册了
+ (void)checkMobileRegister:(NSString *)mobile completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"mobile":mobile};
    [manager POST:LOGINURL(@"checkMobileRegister") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObjectresponseObject:%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *result = [responseObject objectForKey:@"RESULT"];
            if([errorCode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorCode,result);
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorCode,nil);
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
//绑定手机号
+ (void)userBindMobile:(NSString *)mobile newmobile:(NSString *)newmobile validateCode:(NSString *)validateCode completed:(void(^)(NSString * errorCode,NSString *result))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"mobile":mobile,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"newmobile":newmobile,@"validateCode":validateCode};
    [manager POST:LOGINURL(@"userBindMobile") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObjectresponseObject:%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSString *result = [responseObject objectForKey:@"RESULT"];
            if([errorCode isEqualToString:@"0"])
            {
                if (completed)
                {
                    completed(errorCode,result);
                }
            }
            else if([errorCode isEqualToString:@"ME22007"])
            {
                if (completed)
                {
                    completed(errorCode,@"主人,你输入的验证码有误哟");
                }
            }
            else
            {
                if (completed)
                {
                    completed(errorCode,@"主人,请求失败哦");
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",@"主人,网络不给力啊,请检查一下网络吧");
        }
        
    }];
}
//获取版本信息
+ (void)queryUpToDateVersionCompleted:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:LOGINURL(@"queryUpToDateVersion") parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorCode,result);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }

    }];
}
//获取服务频道列表
+ (void)getCustomDefineInfo:(NSString *)startPage pageCount:(NSString *)pageCount longitude:(NSString *)longitude latitude:(NSString *)latitude defineName:(NSString *)defineName actionType:(NSString *)actionType completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"startPage":startPage,@"pageCount":pageCount,@"isDetail":@"1",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"longitude":longitude,@"latitude":latitude,@"defineName":defineName,@"actionType":actionType};
    [manager POST:LOGINURL(@"getCustomDefineInfo") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorCode,result);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

//获取服务频道内容
+ (void)getServiceContent:(NSString *)startPage pageCount:(NSString *)pageCount serverID:(NSString *)serverID  completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"startPage":startPage,@"pageCount":pageCount,@"serviceID":serverID,@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getServiceContent") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorCode,result);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}

#pragma mark - 更新个人信息
+ (void)putInforInNSUserDefaults:(NSDictionary *)resultDic
{
    PersonInfo *presonInfo = [PersonInfo sharePersonInfo];
    presonInfo.phoneString = [resultDic objectForKey:@"mobile"];
    presonInfo.sexString = [resultDic objectForKey:@"gender"];
    presonInfo.carNumberString =[resultDic objectForKey:@"plateNumber"];//车牌
    presonInfo.driveString =[resultDic objectForKey:@"drivingLicense"];//驾驶号
    presonInfo.nameString = [resultDic objectForKey:@"name"];
    presonInfo.nicknameString = [resultDic objectForKey:@"nickname"];
    presonInfo.idNumber = [resultDic objectForKey:@"idNumber"];
    presonInfo.areaStr = [resultDic objectForKey:@"userAreaCode"];
    presonInfo.birthday = [resultDic objectForKey:@"birthday"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strImage = [resultDic objectForKey:@"userHeadName"];
    
    [defaults setObject:[resultDic objectForKey:@"name"] forKey:kName];
    [defaults setObject:[resultDic objectForKey:@"gender"] forKey:kSex];
    [defaults setObject:[resultDic objectForKey:@"nickname"] forKey:kNickName];
    [defaults setObject:[resultDic objectForKey:@"mobile"] forKey:kPhoneNumber];
    NSString *userAreaCode = [resultDic objectForKey:@"userAreaCode"];
    if(userAreaCode==nil||[userAreaCode isEqual:[NSNull null]])
    {
        userAreaCode = @"";
    }
    [defaults setObject:userAreaCode forKey:kArea];
    [defaults setObject:[resultDic objectForKey:@"plateNumber"] forKey:kLicenseNumber];
    [defaults setObject:[resultDic objectForKey:@"drivingLicense"] forKey:kDrivingLicense];
    [defaults setObject:@"0" forKey:kDegree];
    [defaults setObject:[resultDic objectForKey:@"idNumber"] forKey:kIDNumber];
    [defaults setObject:[resultDic objectForKey:@"birthday"] forKey:kBirthday];
    
    if(strImage.length>0)
    {
        presonInfo.senderUserHeadName = strImage;
        [defaults setObject:strImage forKey:@"iconString"];
        [defaults setObject:strImage forKey:kHeadImageUrl];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGetUserImage" object:nil userInfo:nil];
    }
    [defaults synchronize];
}

//流量查询
+ (void)getFlowInfoCompleted:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed
{
    AFHTTPRequestOperationManager * manager = [RequestManager getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString};
    [manager POST:LOGINURL(@"getFlowInfo") parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObjectresponseObject:%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *errorCode = [responseObject objectForKey:@"ERRORCODE"];
            NSDictionary *result = [responseObject objectForKey:@"RESULT"];
            if (completed)
            {
                completed(errorCode,result);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed)
        {
            completed(@"-1",nil);
        }
    }];
}













@end
