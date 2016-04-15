//
//  HistoryModel.h
//  微密
//
//  Created by mirrortalk on 15/9/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
@property (nonatomic,copy) NSString *actionName;
@property (nonatomic,copy) NSString *actionType;//
@property (nonatomic,copy) NSString *customParameter;//
@property (nonatomic,copy) NSString *customType;//
@property (nonatomic,copy) NSString *parameterName;//频道名
@property (nonatomic,copy) NSString *updateTime;//时间
@end
