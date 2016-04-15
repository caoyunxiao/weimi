//
//  SetModelZFJ.h
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetModelZFJ : NSObject

@property (nonatomic,copy) NSString *actionName;//按键名词
@property (nonatomic,copy) NSString *actionType;//作用类型。3：吐槽按键 4：语音命令 5：群组语音
@property (nonatomic,copy) NSString *customParameter;//自定义类型对应的参数
@property (nonatomic,copy) NSString *customType;//自定义类型
@property (nonatomic,copy) NSString *parameterName;//参数名称
@property(nonatomic,strong) NSNumber *talkStatus;
@property(nonatomic,copy)NSString *logo;

@end
