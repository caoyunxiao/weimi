//
//  ChannelViewController.h
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ChannelViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    NSMutableArray *_dataArray;//数据源
    NSMutableArray *_dataMutableArray;
    NSMutableArray *_settingArr;
    NSInteger _buttonTag;
    UIAlertView *_alert;
    BOOL _isSearch;
}



- (IBAction)buttonClick:(UIButton *)sender;
@property(nonatomic,assign)BOOL firstRefresh;//首次进入刷新
@property (weak, nonatomic) IBOutlet UIView *channelTopView;

@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UITableView *channelTableView;

@property (nonatomic,copy) NSString *titleStr;//标题




@end
