//
//  ContractInfo.h
//  微密
//
//  Created by longlz on 14-7-25.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractInfo : NSObject


//IMEI
@property(copy,nonatomic)NSString *imeiString;

//用户提现的账号
@property(copy,nonatomic)NSString *withdrawAccount;

//用户可提现的金额
@property(copy,nonatomic)NSString *withdrawDepositAmount;


//点击提现领取，申请通过后，最晚打到账户的时间
@property(copy,nonatomic)NSString *allowWithdrawTime;

// 1：缴纳押金；2：月返还押金；3：申请退还押金；4：用户申请提现；5：押金提现；6：确认退还押金；7：申请换货；8：确认换货；9：注销
@property(copy,nonatomic)NSString *changedType;

//1：用户未缴纳押金状态；2：用户已缴纳押金状态；3：用户返还押金状态；4：用户已全部收回押金状态；5：用户申请退出合约状态；6：确认用户退出合约状态；7：该IMEI被注销状态；8：申请换货状态
@property(copy,nonatomic)NSString *depositStatus;

//改变押金数额
@property(copy,nonatomic)NSString *changedAmount;

//合约类型，1 最新  2历史
@property(copy,nonatomic)NSString *contractType;


//是否自动转帐
@property(copy,nonatomic)NSString *autoWithdraw;


//遭受冻结的押金
@property(copy,nonatomic)NSString *frozenDepositAmount;

//总押金
@property(copy,nonatomic)NSString *totalDepositAmount;

//押金类型
@property(copy,nonatomic)NSString *depositType;

//备注
@property(copy,nonatomic)NSString *remark;

//更新时间
@property(copy,nonatomic)NSString *updateTime;



@end
