//
//  FootHeaderView.h
//  微密
//
//  Created by APP on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^headerBlock)(int kHeaderTag);
@interface FootHeaderView : UIView
@property (nonatomic,copy)headerBlock headerCallBack;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet FootHeaderView *backView;
@property (weak, nonatomic) IBOutlet UIWebView *cityWebView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *gradeAndTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (copy,nonatomic)NSString *cityAndPointText;
@property (weak, nonatomic) IBOutlet UILabel *cityAndPointLabel;

@end
