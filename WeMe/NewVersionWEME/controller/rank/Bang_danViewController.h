//
//  Bang_danViewController.h
//  微密
//
//  Created by wemedev on 15/3/24.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
#import "myJumpButton.h"

@interface Bang_danViewController : BasesViewController{
    
    UIView *_systemMessageView;         //头部系统消息界面
    UILabel *_systemMessageLabel;       //头部系统消息显示文本
    NSTimer *_timer;                    //时间控制器
    UIAlertView *_alertBangDing;        //绑定警告视图
    
    NSString *_imeiString;              //IMEI号
    NSString *_phoneString;             //手机号
    
    UIView *_advertisementView;         //广告界面
    NSTimer *_myTimer;                  //定时器
    int _iTimer;                        //设置显示时间
    myJumpButton *_myButton;            //自定义跳过按钮
    MoreModely *_adCountDownModels;     //首页广告model
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;//底层滚动视图

- (IBAction)wemeTaskButton:(UIButton *)sender;//系统任务
- (IBAction)rankButtonClick:(UIButton *)sender;//全部和本月排名
- (IBAction)footPrintClick:(UIButton *)sender;//足迹按钮点击事件事件



@end
