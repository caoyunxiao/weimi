//
//  BaiduPanoOverlay.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    BaiduPanoOverlayTypeLabel,
    BaiduPanoOverlayTypeImage,
    BaiduPanoOverlayTypeUnknown,
} BaiduPanoOverlayType;
@interface BaiduPanoOverlay : NSObject
@property(strong, nonatomic) NSString *overlayKey;      // 标识此Overlay的ID，用来取得此Overlay对象
@property(assign, nonatomic) BaiduPanoOverlayType type; // 覆盖物的类型，照片或者文字
@property(assign, nonatomic) NSInteger x;               // 覆盖物的x坐标值
@property(assign, nonatomic) NSInteger y;               // 覆盖物的y坐标值
@property(assign, nonatomic) NSInteger z;               // 覆盖物的z高度

@end
