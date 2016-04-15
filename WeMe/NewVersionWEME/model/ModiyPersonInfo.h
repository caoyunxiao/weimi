//
//  ModiyPersonInfo.h
//  微密
//
//  Created by longlz on 14-7-24.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ModifyPersonInfoBlcok)(BOOL isFinised);


@interface ModiyPersonInfo : NSObject


- (void)modifyPersonInfoNickname:(NSString *)nickname info:(ModifyPersonInfoBlcok)info;

- (void)modifyPersonInfoName:(NSString *)name info:(ModifyPersonInfoBlcok)info;

- (void)modifyPersonInfoSex:(int)Sex info:(ModifyPersonInfoBlcok)info;

- (void)modifyPersonInfoPlateNumber:(NSString *)plateNumber info:(ModifyPersonInfoBlcok)info;

- (void)modifyPersonInfoDrivingLicense:(NSString *)drivingLicense info:(ModifyPersonInfoBlcok)info;


@end
