//
//  ModiyPersonInfo.m
//  微密
//
//  Created by longlz on 14-7-24.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ModiyPersonInfo.h"
#import "HTTPPostManger.h"
#import "PersonInfo.h"


@implementation ModiyPersonInfo


- (void)modifyPersonInfoNickname:(NSString *)nickname info:(ModifyPersonInfoBlcok)info
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&nickname=%@&accountID=%@",SecretOrAppkey,nickname,[PersonInfo sharePersonInfo].accountIDString];
    [HTTPPostManger requestWithURL:LOGINURL(@"fixUserInfo.do") bodyString:bodyString finish:^(NSData *data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            [PersonInfo sharePersonInfo].nicknameString = nickname;
            
            if (info) {
                info(YES);
            }
        }else
        {
            if (info) {
                info(NO);
            }
        }
    } Failed:^(NSError *error) {
        if (info) {
            info(NO);
        }
    }];
}

- (void)modifyPersonInfoName:(NSString *)name info:(ModifyPersonInfoBlcok)info
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&name=%@&accountID=%@",SecretOrAppkey,name,[PersonInfo sharePersonInfo].accountIDString];
    [HTTPPostManger requestWithURL:LOGINURL(@"fixUserInfo.do") bodyString:bodyString finish:^(NSData *data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
         {
             [PersonInfo sharePersonInfo].nameString = name;

             if (info) {
                 info(YES);
             }
         }else
         {
             if (info) {
                 info(NO);
             }
         }
     } Failed:^(NSError *error) {
         if (info) {
             info(NO);
         }
     }];
}

- (void)modifyPersonInfoSex:(int)Sex info:(ModifyPersonInfoBlcok)info
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&gender=%d&accountID=%@",SecretOrAppkey,Sex,[PersonInfo sharePersonInfo].accountIDString];
    [HTTPPostManger requestWithURL:LOGINURL(@"fixUserInfo.do") bodyString:bodyString finish:^(NSData *data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
         {
             [PersonInfo sharePersonInfo].sexString = [NSString stringWithFormat:@"%d",Sex];
             
             if (info) {
                 info(YES);
             }
         }else
         {
             if (info) {
                 info(NO);
             }
         }
     } Failed:^(NSError *error) {
         if (info) {
             info(NO);
         }
     }];
}

- (void)modifyPersonInfoPlateNumber:(NSString *)plateNumber info:(ModifyPersonInfoBlcok)info
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&plateNumber=%@&accountID=%@",SecretOrAppkey,plateNumber,[PersonInfo sharePersonInfo].accountIDString];
    [HTTPPostManger requestWithURL:LOGINURL(@"fixUserInfo.do") bodyString:bodyString finish:^(NSData *data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
         {
             [PersonInfo sharePersonInfo].carNumberString = plateNumber;

             if (info) {
                 info(YES);
             }
         }else
         {
             if (info) {
                 info(NO);
             }
         }
     } Failed:^(NSError *error) {
         if (info) {
             info(NO);
         }
     }];
}

- (void)modifyPersonInfoDrivingLicense:(NSString *)drivingLicense info:(ModifyPersonInfoBlcok)info
{
    NSString *bodyString = [NSString stringWithFormat:@"%@&drivingLicense=%@&accountID=%@",SecretOrAppkey,drivingLicense,[PersonInfo sharePersonInfo].accountIDString];
    [HTTPPostManger requestWithURL:LOGINURL(@"fixUserInfo.do") bodyString:bodyString finish:^(NSData *data)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
         {
             [PersonInfo sharePersonInfo].driveString = drivingLicense;

             if (info) {
                 info(YES);
             }
         }else
         {
             if (info) {
                 info(NO);
             }
         }
     } Failed:^(NSError *error) {
         if (info) {
             info(NO);
         }
     }];
}



@end
