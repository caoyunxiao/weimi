//
//  MyChannelViewController.h
//  微密
//
//  Created by MacDev on 15/4/16.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface MyChannelViewController : BasesViewController
@property(nonatomic,assign)BOOL firstRefresh;//首次进入刷新
//@property(nonatomic,copy)NSString * titleName;
//@property(nonatomic,copy)NSString * requestType;//请求数据的类型  1我创建的 2我加入的 3我关注的

@property (weak, nonatomic) IBOutlet UIButton *createChannelButton;//我创建的
@property (weak, nonatomic) IBOutlet UIButton *myConcernChannelBtn;//我关注的
@property (weak, nonatomic) IBOutlet UIView *buttonView;






@end
