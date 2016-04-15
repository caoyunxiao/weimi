//
//  FootHeaderViewNew.h
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootHeaderViewNew : UIView
@property (weak, nonatomic) IBOutlet UIWebView *cityWebView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *gradeAndTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (copy,nonatomic)NSString *cityAndPointText;
@property (weak, nonatomic) IBOutlet UILabel *cityAndPointLabel;
@end
