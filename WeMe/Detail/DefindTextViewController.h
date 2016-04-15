//
//  DefindTextViewController.h
//  微密
//
//  Created by iOS Dev on 14-9-13.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceAndProtocolView.h"


#pragma mark --
#pragma mark --  合约

@interface DefindTextViewController : UIViewController<ServiceAndProtocolViewDelegate,UIWebViewDelegate>{
    UIWebView *_webView;
}

@end
