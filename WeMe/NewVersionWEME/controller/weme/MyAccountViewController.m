
//
//  MyAccountViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MyAccountViewController.h"
#import "DetailWebViewViewController.h"
#import "PersonInfo.h"
#import <WebKit/WebKit.h>
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"道客钱包";
     self.scroll.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + self.textView.bounds.size.height);
//    self.daokeBill.userInteractionEnabled = YES;
//    self.daokeShop.userInteractionEnabled = YES;
}


- (IBAction)AccountButtonAction:(UIButton *)sender {
    DetailWebViewViewController *detail = [[DetailWebViewViewController alloc] init];
    
    PersonInfo *person = [PersonInfo sharePersonInfo];
    NSString *account = person.accountIDString;
    
    if (sender.tag == 300) {//账户
        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/balance?accountID=%@",account];
        
        detail.url = accountURL;
    }else if (sender.tag == 301){//余额
        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/bill?accountID=%@",account];
        detail.url = accountURL;


    }else if (sender.tag == 302){//商城
        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/sergoodslist?accountID=%@",account];
        detail.url = accountURL;


    }else if (sender.tag == 303){//购买保险
        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/insurance/create?accountID=%@",account];
        detail.url = accountURL;

        
    }else if (sender.tag == 304){//保险欲购金

        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/insurance?accountID=%@",account];
        detail.url = accountURL;
        
    }else if (sender.tag == 305){//捐献社区


        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/donation?accountID=%@",account];
        detail.url = accountURL;
    }else if (sender.tag == 306){//充值

        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/phoneFee?accountID=%@",account];
        detail.url = accountURL;
        
    }else if (sender.tag == 307){//提现
        

        NSString *accountURL = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/withdraw?accountID=%@",account];
        detail.url = accountURL;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
//    [self presentViewController:detail animated:YES completion:nil];

}

@end
