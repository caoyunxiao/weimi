//
//  FunctionModel.h
//  微密
//
//  Created by longlz on 14-7-29.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionSettingDB.h"

typedef void(^GetListFunctionBlock)(NSMutableArray *listArray);

typedef void(^SetFunctionBlock)(BOOL BSucceeed);

@interface FunctionModel : NSObject
{
    FunctionSettingDB *_db;
    NSMutableArray *_allListArray;
}

- (void)getListFunction:(GetListFunctionBlock)listFunction;


- (void)setListFunction:(NSMutableArray *)listArray setFunction:(SetFunctionBlock)setFunction;


@end
