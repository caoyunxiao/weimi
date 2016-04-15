//
//  DetailWebViewController.h
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface DetailWebViewController : BasesViewController<UIWebViewDelegate>{
    
    UIWebView *_DetailWebView;
}

@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *titleName;

@end
