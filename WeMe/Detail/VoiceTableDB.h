//
//  VoiceTableDB.h
//  微密
//
//  Created by iOS Dev on 14-8-29.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoiceInfo.h"
#import "SDBManager.h"



@interface VoiceTableDB : NSObject
{
    FMDatabase *_db;
}

- (NSString *)createVoiceDataBase;


- (void)addVoice:(VoiceInfo *)VoiceInfo;


- (void)deleteVoiceTable;


- (NSArray *)selectVoiceAll;


- (NSArray *)selectVoiceLimit:(int)limit;


- (NSString *)selectLocationURL:(NSString *)networkURL;


- (void)updataWithVoice:(NSString *)netWorkURL location:(NSString *)locationURL;


@end
