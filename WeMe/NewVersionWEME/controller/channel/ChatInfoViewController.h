//
//  ChatInfoViewController.h
//  HiChat
///  Copyright (c) 2015年 why All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface ChatInfoViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView * _textView;
    UITextField * _textFiled;/////////////////
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)chatDBModel * user;
//@property (nonatomic,strong)NewChannelModel * user;
@property (nonatomic,weak)NSMutableDictionary * chatInfos;
@property (nonatomic,strong)NSMutableArray * chatArray;
@property(nonatomic,copy)NSString * friendname;//好友的名字
@property(nonatomic,assign)BOOL isxiaoxi;//是否是消息
@end
