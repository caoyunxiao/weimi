//
//  ApplyFamilyModel.m
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ApplyFamilyModel.h"
#import "Encryption.h"
#import "HTTPPostManger.h"


@implementation ApplyFamilyModel
  

- (void)applyFamilyConnection:(NSString *)accountID parameterType:(int)parameterType name:(NSString *)name applyFamil:(ApplyFamilModelBlock)applyFamil
{
    NSString *uuidString = [FamilyInfo shareFamilyInfo].uuidString;
    
     NSString *bodyString = [NSString stringWithFormat:@"%@&accountID=%@&parameterType=%d&phoneImei=%@&name=%@",
                             SecretOrAppkey,accountID,parameterType,uuidString,name];
    
    [HTTPPostManger requestWithURL:LOGINURL(@"applyConnectSendWeibo.do") bodyString:bodyString  finish:^(NSData *data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        
        if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:accountID forKey:kFamilyPhoneOrIMEI];
            [defaults setObject:@"" forKey:kNameString];
            [defaults setObject:@"" forKey:kpassworldString];
            [defaults synchronize];
            
            [FamilyInfo shareFamilyInfo].receiceID = accountID;
            
            [FamilyInfo shareFamilyInfo].parameterType = parameterType;
            
            [FamilyInfo shareFamilyInfo].uuidString = uuidString;
            
            if (applyFamil)
            {
                applyFamil(0);
            }
        }else if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"1"])
        {
            
            NSString *accountID = [dict objectForKey:@"accountID"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:accountID forKey:kFamilyPhoneOrIMEI];
            [defaults setObject:@"" forKey:kNameString];
            [defaults setObject:@"" forKey:kpassworldString];
            [defaults synchronize];
            
            [FamilyInfo shareFamilyInfo].receiceID = accountID;
            
            [FamilyInfo shareFamilyInfo].parameterType = parameterType;
            
            [FamilyInfo shareFamilyInfo].uuidString = uuidString;
            [FamilyInfo shareFamilyInfo].accountID = accountID;
            
            if (applyFamil)
            {
                applyFamil(100);
            }
        }
        else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18091"])
        {
            if (applyFamil)
            {
                applyFamil(1);
            }
        }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18068"])
        {
            if (applyFamil)
            {
                applyFamil(2);
            }
        }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18006"])
        {
            if (applyFamil)
            {
                applyFamil(3);
            }
        }else
        {
            if (applyFamil) {
                applyFamil(4);
            }
        }
    }
    Failed:^(NSError *error)
     {
         if (applyFamil)
         {
             applyFamil(5);
         }
     }];
}

- (void)applyCodeConnection:(NSString *)imeiString codeBlock:(ApplyCodeModelBlick)codeBlock
{
    Encryption *des = [[Encryption alloc]init];
    
    NSString *uuidString = [FamilyInfo shareFamilyInfo].uuidString;
    NSString *bodyString = [NSString stringWithFormat:@"%@&phoneImei=%@&IMEI=%@",SecretOrAppkey,uuidString,imeiString];
    
    [HTTPPostManger requestWithURL:LOGINURL(@"applyConnScan.do") bodyString:bodyString finish:^(NSData *data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dic objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            NSString *familyRecvID = [[dic objectForKey:@"RESULT"]objectForKey:@"accountID"];
            
            NSString *familyNickname = [[dic objectForKey:@"RESULT"]objectForKey:@"nickname"];

            NSString *deIMEI = [des decryptUseDES:imeiString key:IMEIKey];
            
            [FamilyInfo shareFamilyInfo].receiceID = deIMEI;
            [FamilyInfo shareFamilyInfo].parameterType = 3;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:deIMEI forKey:kFamilyPhoneOrIMEI];
            [defaults setObject:familyRecvID forKey:kFamilyRecAcID];
            [defaults setObject:familyNickname forKey:kFamilyRecNickname];
            [defaults setObject:@"我" forKey:kPhoneNickname];
            [defaults setObject:@"0" forKey:kAppStation];
            [defaults setObject:@"" forKey:kNameString];
            [defaults setObject:@"" forKey:kpassworldString];
            [defaults synchronize];
            
            //ME01023
            if (codeBlock)
            {
                codeBlock(0);
            }
        }
        else if ([[dic objectForKey:@"ERRORCODE"] isEqualToString:@"ME01023"])
        {
            if (codeBlock)
            {
                codeBlock(1);
            }
        }
        else
        {
            if (codeBlock)
            {
                codeBlock(2);
            }
        }
    }
    Failed:^(NSError *error)
    {
        if (codeBlock)
        {
            codeBlock(3);
        }
    }];
}




@end
