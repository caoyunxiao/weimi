//
//  RecordingButton.h
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RecordingButtonDelegate <NSObject>

- (void)touchBegin;

- (void)touchEnd;

@end

@interface RecordingButton : UIButton

@property(assign,nonatomic)id<RecordingButtonDelegate> delegate;

@end
