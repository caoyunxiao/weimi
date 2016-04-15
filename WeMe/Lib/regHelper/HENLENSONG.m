//
//  HENLENSONG.m
//  chuangchaungyingxiao
//
//  Created by ccapp on 14-8-19.
//  Copyright (c) 2014年 ccapp. All rights reserved.
//

#import "HENLENSONG.h"

@implementation HENLENSONG

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//^[(86)|0]?(13\d{9})|(15\d{9})|(17\d{9})|(18\d{9})$
//^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$

/*车牌号验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

+ (BOOL) isRightdate:(NSString*)date
{
    NSString * dateRegex = @"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$";
    
    NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dateRegex];

    return [dateTest evaluateWithObject:date];
}


//
+ (BOOL) isRightNumber:(NSString*)number
{
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$" options:0 error:nil];
    
    if (regex2)
        
    {//对象进行匹配
        
        NSTextCheckingResult *result2 = [regex2 firstMatchInString:number options:0 range:NSMakeRange(0, [number length])];
        
        if (result2)  {
            
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    else
        return NO;
}

+ (BOOL) isRightNameWithNumberAndEnglishAndHanZi:(NSString*)msg
{
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5_a-zA-Z0-9_]{4,16}" options:0 error:nil];
    
    if (regex2)
        
    {//对象进行匹配
        
        NSTextCheckingResult *result2 = [regex2 firstMatchInString:msg options:0 range:NSMakeRange(0, [msg length])];
        
        if (result2)  {
            
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    else
        return NO;
}

+ (BOOL) isRightLetterBeginAndContainNumber:(NSString*)string
{
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z][a-zA-Z0-9]*$" options:0 error:nil];
    
    if (regex2)
        
    {//对象进行匹配
        
        NSTextCheckingResult *result2 = [regex2 firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if (result2)  {
            
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    else
        return NO;
}
@end
