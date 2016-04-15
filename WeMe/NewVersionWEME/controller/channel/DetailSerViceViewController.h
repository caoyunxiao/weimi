//
//  DetailSerViceViewController.h
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "SetModelZFJ.h"
#import "DetailSerViceCell.h"

@interface DetailSerViceViewController : BasesViewController<UITableViewDataSource,UITableViewDelegate,detailSerViceCellDelgate>{
    
    NSMutableArray *_firstArray;
    NSMutableArray *_secondArray;
    float widthBtn;
    NSInteger _arrayCount;
    NSMutableArray *_UIViewArray;
    BOOL _isClick;
    NSInteger _indexButton;
    NSInteger _startPage;
    NSInteger _pageCount;
    NSMutableArray *_dataArray;//数据源
    UITapGestureRecognizer *_singleTap;
    SetModelZFJ *_model;
    UIButton *_button;
    UIAlertView *_alert;
}

@property (weak, nonatomic) IBOutlet UITableView *DetailTableView;
@property (weak, nonatomic) IBOutlet UIView *DetailView;

@property (nonatomic,copy) NSString *serverChannelID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *dict;

@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;

@end
