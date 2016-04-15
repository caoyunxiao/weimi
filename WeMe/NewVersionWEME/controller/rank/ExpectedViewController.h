//
//  ExpectedViewController.h
//  微密
//
//  Created by APP on 15/6/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpectedViewController : UIViewController
@property (nonatomic,copy)NSString *strUrl;
@property (weak, nonatomic) IBOutlet UIWebView *expectedWebView;
@property (nonatomic,copy)NSString *text;
@end
