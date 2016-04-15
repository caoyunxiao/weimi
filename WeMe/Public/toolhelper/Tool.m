//
//  Tool.m
//  微密
//
//  Created by weme on 15/9/22.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "Tool.h"

@implementation Tool
/**
 *  分割字符串
 *
 *  @param needSplitStr 需要分割的字符串
 *  @param splitStr     分隔符
 *
 *  @return 分割好的数组
 */
+(NSArray *)splitByStr:(NSString *)needSplitStr splitStr:(NSString *)splitStr{
    
    NSArray *strArr=[NSArray array];
    if ([needSplitStr isEqualToString:@""]) {
        return strArr;
    }
    NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:splitStr];
    strArr=[needSplitStr componentsSeparatedByCharactersInSet:charSet];
    return strArr;
}
/**
 *  获得当前app的版本号
 *
 *  @return 版本号
 */
+(NSString *)getCurrentAPPVersion{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infoArr=[[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    return [infoArr objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  检查当前app是否是最新的版本
 *
 *  @return yes 是 no 不是
 */
+(void)checkCurrentAPPIsLatestNew:(void(^)(BOOL isLatestNew,NSArray *releaseNote))completed{
    dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        [RequestEngine checkAPPStoreAppInfo:^(NSDictionary *resultDic) {
            if (resultDic) {
                NSArray *results=[resultDic objectForKey:@"results"];
                NSDictionary *result=results.lastObject;
                NSString *version=result[@"version"];
                NSString *updateUrl=result[@"trackViewUrl"];
                NSString *releaseNotes=result[@"releaseNotes"];
                NSArray *releaseNoteArr=[Tool splitByStr:releaseNotes splitStr:@"\n"];
                [UserDefaults setObject:updateUrl forKey:appstoreUpdateUrlKey];
                [UserDefaults synchronize];
                if ([[Tool getCurrentAPPVersion] isEqualToString:version]) {
                    if (completed) {
                        completed(YES,releaseNoteArr);
                    }
                }else{
                    if ([version floatValue]>[[Tool getCurrentAPPVersion] floatValue]) {
                        if (completed) {
                            completed(NO,releaseNoteArr);
                        }
                    }else if([version floatValue]==[[Tool getCurrentAPPVersion] floatValue]){
                        NSString *localVersion=[Tool getCurrentAPPVersion];
                        NSArray *versionCharArrAppstore=[Tool splitByStr:version splitStr:@"."];
                        NSArray *versionCharArrLocal=[Tool splitByStr:localVersion splitStr:@"."];
                        if (versionCharArrAppstore.count>=3&&versionCharArrLocal.count>=3) {
                            if ([versionCharArrAppstore[2] floatValue]>[versionCharArrLocal[2] floatValue]) {
                                if (completed) {
                                    completed(NO,releaseNoteArr);
                                }
                            }else{
                                if (completed) {
                                    completed(YES,releaseNoteArr);
                                }
                            }
                        }else if(versionCharArrAppstore.count>=3&&versionCharArrLocal.count<3){
                            if (completed) {
                                completed(NO,releaseNoteArr);
                            }
                        }else{
                            if (completed) {
                                completed(YES,releaseNoteArr);
                            }
                        }
                    }
                }
            }else{
                if (completed){
                    completed(YES,nil);
                }
            }
            
        }];
    });

}

/**
 *  截取热门推荐的字符串
 *
 *  @param needSplitStr 需要被截取的字符串
 *
 *  @return 新的字符串
 */
+(NSString *)subStringByRange:(NSString *)needSplitStr{
    if (needSplitStr.length<=0) {
        return @"微";
    }
    NSString *resultStr=[needSplitStr substringWithRange:NSMakeRange(0, 1)];
    const char *cString=[resultStr UTF8String];
    if (strlen(cString)==3) {//第一个是汉字
        return resultStr;
    }else{//第一个是字母
        if(needSplitStr.length<2){
            return @"微";
        }
         NSString *twoStr=[needSplitStr substringWithRange:NSMakeRange(0, 2)];
        const char *twoCharStr=[twoStr UTF8String];
        if (strlen(twoCharStr)==2) {//前两个是字母
            return twoStr;
        }else{//第一个字母第二个是汉字
            return resultStr;
        }
    }
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  得到一个字符串数组里的高度和
 *
 *  @param arr  数组
 *  @param font 字体
 *
 *  @return <#return value description#>
 */
+(CGFloat)getArrDataHeight:(NSArray*)arr font:(UIFont*)font{
    CGFloat h=0;
    NSInteger count=arr.count>5?5:arr.count;
    for (int i=0; i<count; i++) {
        NSString *singelWord=[NSString stringWithFormat:@"%@",arr[i]];
        if (singelWord.length>20) {
            h+=[Tool sizeWithText:singelWord font:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height*2;
        }else{
            h+=[Tool sizeWithText:singelWord font:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        }
    }
    return h;
}
@end
