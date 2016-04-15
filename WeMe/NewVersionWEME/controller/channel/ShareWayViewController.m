//
//  ShareWayViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShareWayViewController.h"

@interface ShareWayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@end

@implementation ShareWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self uiConfig];//设置UI
    _tableView.tableFooterView = [[UIView alloc]init];
}
- (void)uiConfig
{
    self.chatButton.layer.borderWidth = 1.0;
    self.chatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.shareButton.layer.borderWidth = 1.0;
    self.shareButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.historyButton.layer.borderWidth = 1.0;
    self.historyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
