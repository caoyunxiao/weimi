//
//  ComplaintFriendViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/15.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface ComplaintFriendViewController : BasesViewController
@property(nonatomic,assign)BOOL reportChannel;//1举报频道 0举报好友
@property(nonatomic,copy)NSString * reportObject;//举报对象
@end
