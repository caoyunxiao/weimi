//
//  DBOperation.h
//  微密
//
//  Created by wemeDev on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "chatDBModel.h"
#import "MessagePushModel.h"
#import "MarksModel.h"
#import "MoreModely.h"
#import "MoneyModely.h"

@interface DBOperation : NSObject{
    
    FMDatabase *_db;
}

+(DBOperation *)shareOperation;

//删除聊天表
- (BOOL)delectChatStrTable:(NSString *)tableName;

//创建聊天表
- (BOOL)createChatStrTable:(NSString *)tableName;

//查询数据库表数据个数
- (NSInteger)countOfTable:(NSString *)tableName;

//根据accountID增加一条数据
- (BOOL)addOneDataBaseWithModel:(chatDBModel *)model withTableName:(NSString *)tableName;

//根据accountID查询一条数据
- (chatDBModel *)selectOneDataBaseWithAccountID:(NSString *)accountID withTableName:(NSString *)tableName;

//根据时间查询number数据
- (NSArray *)selectDataBaseOrderByTimerWithStartNumber:(NSString *)StartNumber endNumber:(NSString *)endNumber withTableName:(NSString *)tableName;

//根据时间删除number数据
- (BOOL)delectDataBaseOrderByTimerWithNumber:(NSInteger)number withTableName:(NSString *)tableName;

//增加number数据
- (BOOL)addDataBaseWithArray:(NSArray *)array withTableName:(NSString *)tableName;

//获取第一条数据的rowID
- (NSInteger)getFirstRowID:(NSString *)tableName;


//根据rowid获取数据
- (NSMutableArray*)getDataArrFromDbWithbeginAccount:(NSInteger)begin endAccount:(NSInteger)end withTableName:(NSString *)tableName;

//Information
//创建信息表
- (BOOL)createInformationTable:(NSString *)tableName;

//根据accountID增加一条数据
- (BOOL)addOneInformationDataBaseWithModel:(MessagePushModel *)model withTableName:(NSString *)tableName;

#pragma mark - 群聊/主播标签表
//创建标签表
- (BOOL)createMarksTable:(NSString *)tableName;

//添加一条数据
- (BOOL)addOneMarksWithModel:(MarksModel *)model withTableName:(NSString *)tableName;

//增加全部标签数组
- (BOOL)addMarksWithArray:(NSArray *)array withTableName:(NSString *)tableName;

//查询表里面全部标签数据
- (NSArray *)selectMarksDataBaseWith:(NSString *)tableName;

#pragma mark - 更多界面
//创建更多表
- (BOOL)createMoreTable:(NSString *)tableName;

//添加一条数据
- (BOOL)addOneMoreWithModel:(MoreModely *)model withTableName:(NSString *)tableName;

//增加全部更多数组
- (BOOL)addMoreWithArray:(NSArray *)array withTableName:(NSString *)tableName;

//查询表里面全部更多数据
- (NSArray *)selectMoreDataBaseWith:(NSString *)tableName;

#pragma mark - 道客账户

- (BOOL)createMoneyModelyTable:(NSString *)tableName;

//添加一条数据
- (BOOL)addOneMoneyModelyWithModel:(MoneyModely *)model withTableName:(NSString *)tableName;

//增加全部更多数组
- (BOOL)addMoneyModelyWithArray:(NSArray *)array withTableName:(NSString *)tableName;

//查询表里面全部更多数据
- (NSArray *)selectMoneyModelyDataBaseWith:(NSString *)tableName;

//创建历史纪录表
-(BOOL)createSearchHistoryTable;

//得到所有历史纪录
-(NSArray*)getHistoryList;

//增加历史纪录
-(BOOL)insertHistory:(NSString*)name;

//清空历史纪录
-(BOOL)emptyHistory;

















@end
