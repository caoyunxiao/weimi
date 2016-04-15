//
//  Tool.h
//  微密
//
//  Created by weme on 15/9/22.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
/**
 *  分割字符串
 *
 *  @param needSplitStr 需要分割的字符串
 *  @param splitStr     分割符
 *
 *  @return <#return value description#>
 */
+(NSArray*)splitByStr:(NSString*)needSplitStr splitStr:(NSString*)splitStr;

/**
 *  得到当前app的版本号
 *
 *  @return 版本号
 */
+(NSString*)getCurrentAPPVersion;

/**
 *  检查当前app是否是最新版本
 *
 *  @return yes 是 no 不是
 */
+(void)checkCurrentAPPIsLatestNew:(void(^)(BOOL isLatestNew,NSArray *releaseNote))completed;

/**
 *  截取热门推荐的字符串
 *
 *  @param needSplitStr 需要被截取的字符串
 *
 *  @return 新的字符串
 */
+(NSString*)subStringByRange:(NSString*)needSplitStr;

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  得到一个字符串数组里的高度和
 *
 *  @param arr  数组
 *  @param font 字体
 *
 *  @return <#return value description#>
 */
+(CGFloat)getArrDataHeight:(NSArray*)arr font:(UIFont*)font;
@end
