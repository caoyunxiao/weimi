//
//  ServiceProtocolViewController.h
//  微密
//
//  Created by wemeDev on 15/6/2.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ServiceProtocolViewController : BasesViewController<UIWebViewDelegate>{
    NSString *_filePath;
}
@property (weak, nonatomic) IBOutlet UIWebView *ServiceWebView;

@end
