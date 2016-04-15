//
//  ServiceAndProtocolView.h
//  微密
//
//  Created by iOS Dev on 14-9-13.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ServiceAndProtocolViewDelegate <NSObject>

- (void)daokeIsClick;

@end


@interface ServiceAndProtocolView : UIView

@property(assign,nonatomic)id<ServiceAndProtocolViewDelegate> delegate;


- (IBAction)daokeClick:(id)sender;


@end
