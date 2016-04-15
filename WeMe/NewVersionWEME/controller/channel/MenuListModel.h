//
//  MenuListModel.h
//  微密
//
//  Created by wemeDev on 15/5/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuListModel : NSObject

@property (nonatomic,copy) NSArray *childMenuList;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *mid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *parentID;
@property (nonatomic,copy) NSString *serverChannelID;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *type;

@end
