//
//  TestViewController.h
//  微密
//
//  Created by MacDev on 15/4/15.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
@property(nonatomic,strong)NewChannelModel * model;
@property (nonatomic,copy) NSString *accountID;
@property (nonatomic,copy) NSString *accountNickName;
@property (nonatomic,copy) NSString *pushType;
@property(nonatomic,strong)UIViewController *vc;
@property(nonatomic,copy)NSString *applyIdx;

@property (weak, nonatomic) IBOutlet UITextView *message;
@property(nonatomic,assign)BOOL isFriend;//1添加好友的验证 2 添加频道的验证
@end
