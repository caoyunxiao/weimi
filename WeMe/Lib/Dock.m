//
//  Dock.m
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"
#import "NSString+file.h"


@interface Dock()
{
    // 当前选中了哪个item
    DockItem *_currentItem;
}
@end

@implementation Dock

// init方法内部会调用initWithFramne
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark 添加item
- (void)addDockItemWithIcon:(NSString *)icon
{
    DockItem *item = [DockItem buttonWithType:UIButtonTypeCustom];
    [self addSubview:item];
    
//    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    [item setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
//    [item setImage:[UIImage imageNamed:[icon fileNameAppend:@"-up"]] forState:UIControlStateSelected];
    [item setBackgroundImage:[UIImage imageNamed:[icon fileNameAppend:@"-up"]] forState:UIControlStateSelected];
    
    
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    [self adjustDockItemsFrame];
}

#pragma mark 点击了某个item
- (void)itemClick:(DockItem *)item
{
    // 1.让当前的item取消选中
    _currentItem.selected = NO;
    
    // 2.让新的item选中
    item.selected = YES;
    
    // 3.让新的item变为当前选中
    _currentItem = item;
    
    // 4.调用block
    if (_itemClickBlock) {
        _itemClickBlock((int)item.tag);
    }
}

#pragma mark 调整item的边框
- (void)adjustDockItemsFrame
{
    int count = (int)self.subviews.count;
    
    // 0.算出item的尺寸
    CGFloat itemWidth = self.frame.size.width / count;
    CGFloat itemHeight = self.frame.size.height;
    
    for (int i = 0; i<count; i++) {
        // 1.取出子控件
        DockItem *item = self.subviews[i];
        
        // 2.算出边框
        item.frame = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        
        if (i == 0) { // 3.第0个item选中
            item.selected = YES;
            _currentItem = item;
        }
        
        // 4.设置item的tag
        item.tag = i;
    }
}

// 不要求掌握
#pragma mark 重写设置选中索引的方法
- (void)setSelectedIndex:(int)selectedIndex
{
    // 1.条件过滤
    if (selectedIndex < 0 || selectedIndex >= self.subviews.count) return;
    
    // 2.赋值给成员变量
    _selectedIndex = selectedIndex;
    
    // 3.对应的item
    DockItem *item = self.subviews[selectedIndex];
    
    // 4.相当于点击了这个item
    [self itemClick:item];
}
@end