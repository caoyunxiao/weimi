//
//  headIcon.h
//  WeMe
//
//  Created by weme on 15/10/22.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headIcon : UIView
/**
 *  中间显示的文字
 */
@property(nonatomic,weak)IBOutlet UILabel *centerWordLbl;

+(instancetype)initWithHeadNib;
@end
