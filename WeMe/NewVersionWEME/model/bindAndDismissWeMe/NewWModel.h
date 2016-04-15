//
//  NewWModel.h
//  微密
//
//  Created by MacDev on 15/3/6.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewWModel : NSObject
@property(nonatomic,copy)NSString * status;//是否合法性状态,0可以绑定,1已经绑定过了,2,imei不合法,3,未知错误,联系客服
@property(nonatomic,copy)NSString * accountID;
@property(nonatomic,copy)NSString * legalIMEI;//是否是合法的weme,0不合法,1合法
@property(nonatomic,copy)NSString * nickname;//昵称
@property(nonatomic,copy)NSString * online;//
@property(nonatomic,copy)NSString * usableIMEI;//此微密是否绑定过,0已经绑定,1没有绑定
@property(nonatomic,copy)NSString * hasPassword;//1,已经绑定押金密码
+(NewWModel *)getWeMeModelWithDic:(NSDictionary *)dic;
@end
