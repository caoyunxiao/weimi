//
//  PlistHelper.h
//  微密
//
//  Created by weme on 15/8/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistHelper : NSObject

/**
 *  添加到搜索历史
 *
 *  @param historyName 搜索的关键字
 *
 *  @return
 */
+(void)addToSearchHistory:(NSString*)historyName;

+(void)addsearchHistoryArray:(NSMutableArray *)historyArray;
/**
 *  删除所有历史纪录
 *
 *  @return return value description
 */
+(void)EmptyHistory;

/**
 *  获取历史纪录
 *
 *  @return return value description
 */
+(NSArray*)GetHistoryList; 
@end
