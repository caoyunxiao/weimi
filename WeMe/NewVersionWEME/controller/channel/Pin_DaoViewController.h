//
//  Pin_DaoViewController.h
//  微密
//
//  Created by wemedev on 15/3/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PindaoTableViewCell.h"

@interface Pin_DaoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PindaoButtonDelgate>{
    
    NSArray *_anchorTitleArr;
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *chang_view;



@end
