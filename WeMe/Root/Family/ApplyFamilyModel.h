//
//  ApplyFamilyModel.h
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ApplyFamilModelBlock)(int isApplySucceed);

typedef void(^ApplyCodeModelBlick)(int isSucceed);



@interface ApplyFamilyModel : NSObject


- (void)applyFamilyConnection:(NSString *)accountID parameterType:(int)parameterType name:(NSString *)name applyFamil:(ApplyFamilModelBlock)applyFamil;


- (void)applyCodeConnection:(NSString *)imeiString codeBlock:(ApplyCodeModelBlick)codeBlock;



@end
