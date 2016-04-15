//
//  SUserDB.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SUserDB.h"
#import "ChatInfo.h"

#define kUserTableName @"ChatUser"

@implementation SUserDB

- (id) init
{
    self = [super init];
    
    if (self)
    {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db = [SDBManager defaultDBManager].dataBase;
        
    }
    return self;
}



/**
 * @brief 创建数据库
 */
- (NSString *) createDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kUserTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable)
    {
        // TODO:是否更新数据库
        return @"数据库已经存在";
        
    } else
    {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE ChatUser (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, receiveAccount VARCHAR(50), phoneImei VARCHAR(50) ,iMessageType VARCHAR(2) ,iAccountType VARCHAR(2),mediaUrl VARCHAR(255),networkUrl VARCHAR(255),createTime VARCHAR(50),mediaTimeLength VARCHAR(10),receiveNickname VARCHAR(50),locationNickname VARCHAR(50),nowMessage VARCHAR(2), sendStatus VARCHAR(2))";
        BOOL res = [_db executeUpdate:sql];
        if (!res)
        {
            return @"数据库创建失败";
        } else {
            return @"数据库创建成功";
        }
    }
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (void)addUser:(ChatInfo *) chat
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO ChatUser"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    
    if (chat.receiveAccount) {
        [keys appendString:@"receiveAccount,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.receiveAccount];
    }
    
    if (chat.phoneImei) {
        [keys appendString:@"phoneImei,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.phoneImei];
    }
    
    if (chat.iMessageType) {
        [keys appendString:@"iMessageType,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.iMessageType];
    }
    if (chat.iAccountType) {
        [keys appendString:@"iAccountType,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.iAccountType];
    }
    
    if (chat.mediaUrl) {
        [keys appendString:@"mediaUrl,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.mediaUrl];
    }
    if (chat.createTime) {
        [keys appendString:@"phoneImei,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.createTime];
    }
    
    if (chat.mediaTimeLength) {
        [keys appendString:@"mediaTimeLength,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.mediaTimeLength];
    }
    if (chat.receiveNickname) {
        [keys appendString:@"receiveNickname,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.receiveNickname];
    }
    if (chat.locationNickname) {
        [keys appendString:@"locationNickname,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.locationNickname];
    }
    if (chat.nowMessage) {
        [keys appendString:@"nowMessage,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.nowMessage];
    }
    if (chat.sendStatus) {
        [keys appendString:@"sendStatus,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.sendStatus];
    }
    if (chat.networkUrl) {
        [keys appendString:@"networkUrl,"];
        [values appendString:@"?,"];
        [arguments addObject:chat.networkUrl];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    [_db executeUpdate:query withArgumentsInArray:arguments];
}


/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) deleteUserWithId:(NSString *) uid
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM ChatUser WHERE uid = '%@'",uid];
//    [AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (void)updataWithUser:(ChatInfo *) chat
{
    if (!chat.uid)
    {
        return;
    }
    NSString * query = @"UPDATE ChatUser SET";
    NSMutableString * temp = [[NSMutableString alloc]init];
    
    if (chat.receiveAccount)
    {
        [temp appendFormat:@" receiveAccount = '%@',",chat.receiveAccount];
    }
    if (chat.phoneImei) {
        [temp appendFormat:@" phoneImei = '%@',",chat.phoneImei];
    }
    if (chat.iMessageType)
    {
        [temp appendFormat:@" iMessageType = '%@',",chat.iMessageType];
    }
    if (chat.iAccountType) {
        [temp appendFormat:@" iAccountType = '%@',",chat.iAccountType];
    }
    
    if (chat.mediaUrl)
    {
        [temp appendFormat:@" mediaUrl = '%@',",chat.mediaUrl];
    }
    if (chat.createTime) {
        [temp appendFormat:@" createTime = '%@',",chat.createTime];
    }
    
    if (chat.mediaTimeLength)
    {
        [temp appendFormat:@" mediaTimeLength = '%@',",chat.mediaTimeLength];
    }
    if (chat.receiveNickname) {
        [temp appendFormat:@" receiveNickname = '%@',",chat.receiveNickname];
    }
    if (chat.locationNickname)
    {
        [temp appendFormat:@" locationNickname = '%@',",chat.locationNickname];
    }
    if (chat.nowMessage) {
        [temp appendFormat:@" nowMessage = '%@',",chat.nowMessage];
    }if (chat.sendStatus)
    {
        [temp appendFormat:@" sendStatus = '%@',",chat.sendStatus];
    }
    if (chat.networkUrl)
    {
        [temp appendFormat:@" networkUrl = '%@',",chat.networkUrl];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],chat.uid];
    
    [_db executeUpdate:query];
}



/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */

- (NSArray *)findWithlimit:(int)limit
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM ChatUser"];
    
    query = [query stringByAppendingFormat:@" ORDER BY uid ASC limit %d",limit];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
	while ([rs next])
    {
        ChatInfo *info = [[ChatInfo alloc]init];
        info.uid = [rs stringForColumn:@"uid"];
        info.iMessageType = [rs stringForColumn:@"iMessageType"];
        info.iAccountType = [rs stringForColumn:@"iAccountType"];
        info.phoneImei = [rs stringForColumn:@"phoneImei"];
        info.mediaUrl = [rs stringForColumn:@"mediaUrl"];
        info.createTime = [rs stringForColumn:@"createTime"];
        info.mediaTimeLength = [rs stringForColumn:@"mediaTimeLength"];
        info.receiveNickname = [rs stringForColumn:@"receiveNickname"];
        info.locationNickname = [rs stringForColumn:@"locationNickname"];
        info.nowMessage = [rs stringForColumn:@"nowMessage"];
        info.sendStatus = [rs stringForColumn:@"sendStatus"];
        info.networkUrl = [rs stringForColumn:@"networkUrl"];
        [array addObject:info];
	}
	[rs close];
    return array;
}
@end
