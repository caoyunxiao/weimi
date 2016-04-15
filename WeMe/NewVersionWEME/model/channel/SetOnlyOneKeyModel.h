//
//  SetOnlyOneKeyModel.h
//  微密
//
//  Created by weme on 15/8/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetOnlyOneKeyModel : NSObject
//actionType = 4;
//customParameter = 10086;
//customType = 10;
//status = 1;
@property(nonatomic,copy)NSString *actionType;
@property(nonatomic,copy)NSString *customParameter;
@property(nonatomic,copy)NSString *customType;
@property(nonatomic,copy)NSString *status;
@end
