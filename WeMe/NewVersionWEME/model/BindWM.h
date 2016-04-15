//
//  BindWM.h
//  微密
//
//  Created by MacDev on 15/3/6.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindWM : NSObject
@property(nonatomic,copy)NSString * imeiStr;
-(void)bindWMWithStr:(NSString*)str boudBtn:(UIButton*)boudBtn;
@end
