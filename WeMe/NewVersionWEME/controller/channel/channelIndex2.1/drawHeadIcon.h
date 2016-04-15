//
//  drawHeadIcon.h
//  微密
//
//  Created by weme on 15/10/8.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawHeadIcon : UIView
/**
 *  头像上画的字
 */
@property(nonatomic,copy)NSString *drawTxt;

/**
 *  右边和下边加粗(解决bug)
 */
@property(nonatomic,assign)BOOL isBoldBottomAndRight;


@end
