//
//  DetailWebViewViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/19.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"

@interface DetailWebViewViewController : BasesViewController

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,copy) NSString *url;//URL链接
//@property (nonatomic,copy) NSString *title;//跳转详情页的类型
@end
