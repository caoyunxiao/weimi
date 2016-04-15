//
//  DBOperation.m
//  微密
//
//  Created by wemeDev on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DBOperation.h"
#import "MarksModel.h"
#import "MoreModely.h"

@implementation DBOperation

+(DBOperation *)shareOperation{
    static DBOperation *ope = nil;
    @synchronized(self){
        if (ope == nil) {
            ope = [[self alloc]init];
        }
        return ope;
    }
}

-(id)init
{
    if (self = [super init])
    {
        [self createWEMEDataBase];
    }
    return self;
}

#pragma mark - 创建数据库
-(void)createWEMEDataBase
{
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents/WEMEDataBase.sqlite"];
    //NSLog(@"数据库路径 path == %@",path);
    _db = [[FMDatabase alloc]initWithPath:path];
    [_db open];
}


#pragma 创建搜索历史表
-(BOOL)createSearchHistoryTable{
    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS history (HistoryId INTEGER PRIMARY KEY AUTOINCREMENT, historyName TEXT)";
    return  [_db executeUpdate:sqlStr];
    
}

#pragma 得到所有历史纪录
-(NSArray *)getHistoryList{
    NSString *sqlStr=[NSString stringWithFormat:@"select * from history"];
    FMResultSet*rows=[_db executeQuery:sqlStr];
    NSMutableArray *resutList=[NSMutableArray array];
    while ([rows next]) {
        [resutList addObject:[rows stringForColumn:@"historyName"]];
    }
    return resutList;
}

#pragma 增加历史纪录
-(BOOL)insertHistory:(NSString *)name{
   NSArray *resultArray = [self getHistoryList];
    for (NSString *strName in resultArray) {
        if ([name isEqualToString:strName]) {
            NSString *str=[NSString stringWithFormat:@"delete from history where historyName=%@",strName];
            [_db executeUpdate:str];
        }
    }
    NSString *sqlStr=[NSString stringWithFormat:@"insert into history (historyName) values ('%@')",name];
    return [_db executeUpdate:sqlStr];
}

#pragma 清空历史纪录
-(BOOL)emptyHistory{
    NSString *sqlStr=@"delete from  history where HistoryId>0";
    return [_db executeUpdate:sqlStr];
}

#pragma mark - 删除聊天表
- (BOOL)delectChatStrTable:(NSString *)tableName
{
    NSMutableString *sqlStr = [[NSMutableString alloc]initWithFormat:@"drop table %@",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表删除成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"删除失败:%@",_db.lastError);
        return NO;
    }
}

#pragma mark - 创建聊天表
-(BOOL)createChatStrTable:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(accountID,timerDate,chatStr,headImage,userName,isSucess,remarks)",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表创建成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"创建失败:%@",_db.lastError);
        return NO;
    }
}
#pragma mark - 查询数据库表数据个数
-(NSInteger)countOfTable:(NSString *)tableName
{
    NSString *str = [NSString stringWithFormat:@"select * from %@ ",tableName];
    FMResultSet *set = [_db executeQuery:str];
    NSInteger count = 0;
    while ([set next])
    {
        count ++;
    }
    [set close];
    return count;
}
#pragma mark - 根据accountID增加一条数据
- (BOOL)addOneDataBaseWithModel:(chatDBModel *)model withTableName:(NSString *)tableName
{
    NSMutableArray *timerDateArr=[NSMutableArray array];
    NSString *selectTimerDateSql=[NSString stringWithFormat:@"select timerDate from %@ where accountID='%@'",tableName,model.accountID];
    FMResultSet *set=[_db executeQuery:selectTimerDateSql];
    while ([set next]) {
        [timerDateArr addObject:[set objectForColumnName:@"timerDate"]];
    }
    //[timerDateArr containsObject:model.pushTime] ios太低可能出现不支持的情况
    if (![self isContainObject:timerDateArr objStr:model.pushTime]) {
        NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(accountID,timerDate,chatStr,headImage,userName,isSucess,remarks) values('%@','%@','%@','%@','%@','%@','%@')",tableName,model.accountID,model.pushTime,model.talkContent,model.senderUserHeadName,model.friendNickName,model.isSucess,model.remarks];
        BOOL ret = [_db executeUpdate:sqlStr];
        if (ret) {
            return YES;
        }
        else{
            //NSLog(@"error:%@",_db.lastError);
            return NO;
        }
    }else{
        return NO;
    }
    
}
/**
 *  是否包含
 *
 *  @param arr    数组
 *  @param objStr 包含的字符串
 *
 *  @return <#return value description#>
 */
-(BOOL)isContainObject:(NSArray *)arr objStr:(NSString*)objStr{
    BOOL isContain=NO;
    for (NSString *str in arr) {
        if ([str isEqualToString:objStr]) {
            isContain=YES;
        }
    }
    return isContain;
}
#pragma mark - 获取第一条数据的rowID
- (NSInteger)getFirstRowID:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"select rowid from %@ order by rowid",tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        [mutableArr addObject:[set stringForColumnIndex:0]];
    }
    [set close];
    return [[mutableArr firstObject] integerValue];
}

#pragma mark - 根据accountID查询一条数据
- (chatDBModel *)selectOneDataBaseWithAccountID:(NSString *)accountID withTableName:(NSString *)tableName{
    chatDBModel *model = [[chatDBModel alloc]init];
    return model;
}

#pragma mark - 根据时间查询number数据
- (NSArray *)selectDataBaseOrderByTimerWithStartNumber:(NSString *)StartNumber endNumber:(NSString *)endNumber withTableName:(NSString *)tableName
{
    NSInteger firstRowID = [self getFirstRowID:tableName];
    NSInteger count = [self countOfTable:tableName];
    StartNumber = [NSString stringWithFormat:@"%ld",[StartNumber integerValue]+firstRowID-1];
    NSInteger endNum = [StartNumber integerValue]+firstRowID-1;
    if(endNum>=(firstRowID+count-1))
    {
        endNumber = [NSString stringWithFormat:@"%ld",firstRowID+count-1];
    }
    else
    {
        endNumber = [NSString stringWithFormat:@"%ld",endNum];
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where rowid>=%@ and rowid<=%@",tableName,StartNumber,endNumber];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        chatDBModel *model = [[chatDBModel alloc]init];
        model.accountID = [set stringForColumnIndex:0];
        model.pushTime = [set stringForColumnIndex:1];
        model.talkContent = [set stringForColumnIndex:2];
        model.senderUserHeadName = [set stringForColumnIndex:3];
        model.friendNickName = [set stringForColumnIndex:4];
        model.isSucess = [set stringForColumnIndex:5];
        model.remarks = [set stringForColumnIndex:6];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}
#pragma mark -- 根据rowid获取数据
- (NSMutableArray*)getDataArrFromDbWithbeginAccount:(NSInteger)begin endAccount:(NSInteger)end withTableName:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where rowid>=%@ and rowid<=%@",tableName,[NSString stringWithFormat:@"%ld",(long)begin],[NSString stringWithFormat:@"%ld",(long)end]];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        chatDBModel *model = [[chatDBModel alloc]init];
        model.accountID = [set stringForColumnIndex:0];
        model.pushTime = [set stringForColumnIndex:1];
        model.talkContent = [set stringForColumnIndex:2];
        model.senderUserHeadName = [set stringForColumnIndex:3];
        model.friendNickName = [set stringForColumnIndex:4];
        model.isSucess = [set stringForColumnIndex:5];
        model.remarks = [set stringForColumnIndex:6];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}
#pragma mark - 根据时间删除number数据
- (BOOL)delectDataBaseOrderByTimerWithNumber:(NSInteger)number withTableName:(NSString *)tableName{
    NSInteger count = [self countOfTable:tableName];
    NSInteger firstRowID = [self getFirstRowID:tableName]-1;
    if(count>=number)
    {
        NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where rowid<=%ld",tableName,number+firstRowID];
        BOOL ret = [_db executeUpdate:sqlStr];
        if (ret) {
            return YES;
        }
        else{
            //NSLog(@"删除失败:%@",_db.lastError);
            return NO;
        }
    }
    else
    {
        //NSLog(@"删除失败,删除条数超过数据最大值!");
        return NO;
    }
}

#pragma mark - 增加number数据
- (BOOL)addDataBaseWithArray:(NSArray *)array withTableName:(NSString *)tableName{
    [_db beginTransaction];
    
    for (chatDBModel *model in array) {
        [self addOneDataBaseWithModel:model withTableName:tableName];
    }
    return [_db commit];
}

#pragma mark - 创建信息表
- (BOOL)createInformationTable:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(messageID,senderAccountID,param,createTime,messageType,senderUserHeadName,content,msgTitle)",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表创建成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"创建失败:%@",_db.lastError);
        return NO;
    }
}

#pragma mark - 根据accountID增加一条数据
- (BOOL)addOneInformationDataBaseWithModel:(MessagePushModel *)model withTableName:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(messageID,senderAccountID,param,createTime,messageType,senderUserHeadName,content,msgTitle) values('%@','%@','%@','%ld','%@','%@','%@','%@')",tableName,model.messageID,model.senderAccountID,model.param,model.createTime,model.messageType,model.senderUserHeadName,model.content,model.msgTitle];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret) {
        return YES;
    }
    else{
        //NSLog(@"error:%@",_db.lastError);
        return NO;
    }
}
#pragma mark - 根据时间查询number数据
- (NSArray *)selectInformationTableOrderByTimerWithStartNumber:(NSString *)StartNumber endNumber:(NSString *)endNumber withTableName:(NSString *)tableName
{
    NSInteger firstRowID = [self getFirstRowID:tableName];
    NSInteger count = [self countOfTable:tableName];
    StartNumber = [NSString stringWithFormat:@"%ld",[StartNumber integerValue]+firstRowID-1];
    NSInteger  endNum = [StartNumber integerValue]+firstRowID-1;
    if(endNum>=(firstRowID+count-1))
    {
        endNumber = [NSString stringWithFormat:@"%ld",firstRowID+count-1];
    }
    else
    {
        endNumber = [NSString stringWithFormat:@"%ld",endNum];
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where rowid>=%@ and rowid<=%@",tableName,StartNumber,endNumber];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        MessagePushModel *model = [[MessagePushModel alloc]init];
        model.messageID = [set stringForColumnIndex:0];
        model.senderAccountID = [set stringForColumnIndex:1];
        //model.param = [set stringForColumnIndex:2];
        model.createTime = [[set stringForColumnIndex:3] integerValue];
        model.messageType = [set stringForColumnIndex:4];
        model.senderUserHeadName = [set stringForColumnIndex:5];
        model.content = [set stringForColumnIndex:6];
        model.msgTitle = [set stringForColumnIndex:6];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}

#pragma maerk - 标签的数据操作方法
//创建标签表
- (BOOL)createMarksTable:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(catalogType,name,number,markType)",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表创建成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"创建失败:%@",_db.lastError);
        return NO;
    }
}

//添加一条数据
- (BOOL)addOneMarksWithModel:(MarksModel *)model withTableName:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(catalogType,name,number,markType) values('%@','%@','%@','%@')",tableName,model.catalogType,model.name,model.number,model.markType];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret) {
        return YES;
    }
    else{
        //NSLog(@"error:%@",_db.lastError);
        return NO;
    }
}

//增加全部标签数组
- (BOOL)addMarksWithArray:(NSArray *)array withTableName:(NSString *)tableName
{
    [_db beginTransaction];
    
    for (MarksModel *model in array) {
        [self addOneMarksWithModel:model withTableName:tableName];
    }
    return [_db commit];
}

//查询表里面全部标签数据
- (NSArray *)selectMarksDataBaseWith:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        MarksModel *model = [[MarksModel alloc]init];
        model.catalogType = [set stringForColumnIndex:0];
        model.name = [set stringForColumnIndex:1];
        model.number = [set stringForColumnIndex:2];
        model.markType = [set stringForColumnIndex:3];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}

//创建更多表
- (BOOL)createMoreTable:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(appName,picUrl,remark,url)",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表创建成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"创建失败:%@",_db.lastError);
        return NO;
    }
}

//添加一条数据
- (BOOL)addOneMoreWithModel:(MoreModely *)model withTableName:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(appName,picUrl,remark,url) values('%@','%@','%@','%@')",tableName,model.appName,model.picUrl,model.remark,model.url];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret) {
        return YES;
    }
    else{
        //NSLog(@"error:%@",_db.lastError);
        return NO;
    }
}

//增加全部更多数组
- (BOOL)addMoreWithArray:(NSArray *)array withTableName:(NSString *)tableName
{
    [_db beginTransaction];
    
    for (MoreModely *model in array) {
        [self addOneMoreWithModel:model withTableName:tableName];
    }
    return [_db commit];
}

//查询表里面全部更多数据
- (NSArray *)selectMoreDataBaseWith:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        MoreModely *model = [[MoreModely alloc]init];
        model.appName = [set stringForColumnIndex:0];
        model.picUrl = [set stringForColumnIndex:1];
        model.remark = [set stringForColumnIndex:2];
        model.url = [set stringForColumnIndex:3];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}

#pragma mark - 道客账户

- (BOOL)createMoneyModelyTable:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(createTime,icon,mid,name,url)",tableName];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret)
    {
        //NSLog(@"%@表创建成功!",tableName);
        return YES;
    }
    else
    {
        //NSLog(@"创建失败:%@",_db.lastError);
        return NO;
    }
}

//添加一条数据
- (BOOL)addOneMoneyModelyWithModel:(MoneyModely *)model withTableName:(NSString *)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(createTime,icon,mid,name,url) values('%@','%@','%@','%@','%@')",tableName,model.createTime,model.icon,model.mid,model.name,model.url];
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret) {
        return YES;
    }
    else{
        //NSLog(@"error:%@",_db.lastError);
        return NO;
    }
}

//增加全部更多数组
- (BOOL)addMoneyModelyWithArray:(NSArray *)array withTableName:(NSString *)tableName
{
    [_db beginTransaction];
    
    for (MoneyModely *model in array) {
        [self addOneMoneyModelyWithModel:model withTableName:tableName];
    }
    return [_db commit];
}

//查询表里面全部更多数据
- (NSArray *)selectMoneyModelyDataBaseWith:(NSString *)tableName
{
    //(createTime,icon,mid,name,url)
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next])
    {
        MoneyModely *model = [[MoneyModely alloc]init];
        model.createTime = [set stringForColumnIndex:0];
        model.icon = [set stringForColumnIndex:1];
        model.mid = [set stringForColumnIndex:2];
        model.name = [set stringForColumnIndex:3];
        model.url = [set stringForColumnIndex:4];
        [mutableArr addObject:model];
    }
    [set close];
    return mutableArr;
}


























@end
