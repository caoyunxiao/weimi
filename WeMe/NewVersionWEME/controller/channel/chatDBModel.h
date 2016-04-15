//
//  chatDBModel.h
//  微密
//
//  Created by wemeDev on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatDBModel : NSObject
//content = "{accountID=cllk0KkCCA, talkContent=\U6211\U662f\U804a\U5929\U5185\U5bb9, senderUserHeadName=http://www.baidu.com/1.jpg, ta=\U4ed6, pushTime=1432278297, friendNickName=\U597d\U53cb\U6635\U79f0, accountNickName=\U53d1\U9001\U8005\U7684\U6635\U79f0}";
//        title = talk;
@property (nonatomic,copy) NSString *accountID;   //好友的ID
@property(nonatomic,copy)NSString *  accountNickName;//
@property(nonatomic,copy)NSString * talkContent;//好友的聊天内容
@property(nonatomic,copy)NSString * senderUserHeadName;//用户头像
@property (nonatomic,copy) NSString *friendNickName;   //昵称
@property (nonatomic,copy) NSString *isSucess;    //是否发送成功

@property (nonatomic,copy) NSString *pushTime;    //时间

@property (nonatomic,copy) NSString *remarks;     //备注,1是自己 2是好友
@property(nonatomic,copy)NSString * gender;
+(chatDBModel*)getModelWithDic:(NSDictionary *)dic;
@end
