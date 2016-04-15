//
//  MemberViewController.h
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "MemberTableViewCell.h"

@interface MemberViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource,memberTableViewCellDelgate>{
    
    NSMutableArray *_dataArray;
    NSInteger _pageCount;
    NSString *_curStatus;
    NSInteger _cellAtIndexRow;
    NSInteger _atSection;
}

@property (weak, nonatomic) IBOutlet UITableView *MemberTableView;
@property(nonatomic,copy)NSString * channelNumber;//频道编号
@property(nonatomic,copy)NSString * infoType;// 1.管理员获取在线用户列表 2.普通用户获取在线用户列表//////
@property(nonatomic,copy)NSString * pindaoType;//主播还是群聊频道
@property(nonatomic,assign)BOOL isZhuanYi;//是否是转移频道
@property(nonatomic,assign)BOOL isAdministrator;//是否是管理员



@end
