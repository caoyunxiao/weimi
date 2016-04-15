//
//  DetailInfoViewController.h
//  微密
//
//  Created by longlz on 14-7-14.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
#import "MRZoomScrollView.h"

typedef void(^DetailInfoBlock)();

@interface DetailInfoViewController : BasesViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *_dataArray;
    NSMutableArray *_dataDetailArray;
    UITableView *_tableView;
    UIImageView *_userImageView;
    UIImage *_userImage;
    BOOL _isfirst;
    UIPickerView *_selectSexPicker;
    NSArray *_sexArray;
    UIView *_selectSexPickerView;
    UIButton *_sexButton;
    NSInteger _sexStr;
    
    UIView *_backView;
    UIView *_UIBlackView;//查看大图的黑色背景
    
    UIImageView *_bigImageView;//查看大图
    BOOL _isShowBaoCun;
}

@property (nonatomic,assign)NSInteger areaCode;
@property (nonatomic,assign)NSInteger channelCode;
@property(assign,nonatomic)BOOL isPush;

@property(assign,nonatomic)DetailInfoBlock endBlock;


@property (nonatomic, retain) UIScrollView      *scrollView;
@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;


@end
