//
//  ComplaintFriendViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/15.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ComplaintFriendViewController.h"

@interface ComplaintFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComplaintFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 20);
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendActionButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendActionButton:(UIButton *)sender{
    if (!(_textView.text.length>0)) {
        Alert(@"主人,你还没有填写举报原因呢");
        return;
    }
    NSString * content =  (_textView.text.length>140)?[_textView.text substringToIndex:140]:_textView.text;
    NSString * reportType = _reportChannel?@"1":@"2";
    NSDictionary * dic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"reportObject":_reportObject,@"reportType":reportType,@"content":content};
    [self refreshWithStatus:YES];
    [RequestEngine insertTeportInfoWithDic:dic completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            Alert(@"主人,举报成功了哦");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            Alert(@"主人,举报没有发送成功,请稍后再试试哟")
        }
    }];
    
}
@end
