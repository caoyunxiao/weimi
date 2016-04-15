//
//  PlistHelper.m
//  微密
//
//  Created by weme on 15/8/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "PlistHelper.h"

@implementation PlistHelper

/**
 *  增加到历史纪录去
 *
 *  @param historyName <#historyName description#>
 *
 */
+(void)addToSearchHistory:(NSString *)historyName{
    
    NSMutableArray *listArr=[NSMutableArray array];
    if ([NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath].count>0) {
        listArr=[NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath];
        
        for (int i=0; i<listArr.count; i++) {
            if ([listArr[i] isEqualToString:historyName]) {
                [listArr removeObjectAtIndex:i];
            }
        }
    }
    [listArr addObject:historyName];
    [listArr writeToFile:searchHistoryDataPath atomically:YES];
}

+(void)addsearchHistoryArray:(NSMutableArray *)historyArray
{
    if ([NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath].count>0) {
        historyArray=[NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath];
    }
//    for (int i=0; i<historyArray.count; i++) {
//        if ([historyArray[i] isEqualToString:historyArray[++i]]) {
//            [historyArray removeObjectAtIndex:i];
//        }
//    }
    [historyArray writeToFile:searchHistoryDataPath atomically:YES];
}

/**
 *  清空历史纪录
 *
 *  @return <#return value description#>
 */
+(void)EmptyHistory{
    NSMutableArray *arrList=[NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath];
    if (arrList.count>0) {
        [arrList removeAllObjects];
    }
    [arrList writeToFile:searchHistoryDataPath atomically:YES];
}

/**
 *  获取历史纪录
 *
 *  @return <#return value description#>
 */
+(NSArray *)GetHistoryList{
    
    //倒序返回一个数组
    return [[[NSMutableArray arrayWithContentsOfFile:searchHistoryDataPath] reverseObjectEnumerator]allObjects];
}

@end
