//
//  NewCashViewController.h
//  微密
//
//  Created by mirrtalk on 15/3/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCashViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
//    UITextField *_secretCodeText;  //密码框
    UISwitch *_isVoluntarySwitch;  //自动转账控件
    UILabel *_tiShiView;
    UILabel *_tishiLabel;

    BOOL   _isSucceed;
    NSUserDefaults * _defaults;//
    
    ModelView *_modelView;
}
@property (nonatomic,strong) NSString *withdrawDepositAmountString;

@property(copy,nonatomic)NSString *depositType;

@end
