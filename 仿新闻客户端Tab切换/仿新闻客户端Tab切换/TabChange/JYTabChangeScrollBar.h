//
//  JYTabChangeScrollBar.h
//  仿新闻客户端Tab切换
//
//  Created by Gu,Jinyue on 2018/8/22.
//  Copyright © 2018年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYScrollBarDelegate;

#pragma mark - JYScrollBarItem

@interface JYScrollBarItem : UIButton

@end

#pragma mark - JYTabChangeScrollBar

@interface JYTabChangeScrollBar : UIView

// 需要展示的Item数组
@property (nonatomic, strong) NSArray<JYScrollBarItem *> *items;
// 当前选中Item
@property (nonatomic, strong) JYScrollBarItem *selectedItem;
// 当前选中Item的Index
@property (nonatomic, assign) NSInteger selectedItemIndex;

// ScrollBar左右间距
@property (nonatomic, assign) CGFloat edgeDistance;
// item之间的间距
@property (nonatomic, assign) CGFloat itemSpacing;

// 是否显示下划线
@property (nonatomic, assign) BOOL showActiveIndicator;
// 下划线高度
@property (nonatomic, assign) CGFloat indicatorHeight;
// 下划线颜色
@property (nonatomic, strong) UIColor *indicatorColor;

// item字体颜色和大小(有默认值, 外部可自定义传入)
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont  *normalFont;
@property (nonatomic, strong) UIFont  *selectedFont;

@property (nonatomic, weak) id<JYScrollBarDelegate> delegate;

// 根据传入的文字生成Item数组
+ (NSArray<JYScrollBarItem *> *)itemsWithTextArray:(NSArray<NSString *> *)textArray;

@end

#pragma mark - JYScrollBarDelegate

@protocol JYScrollBarDelegate <NSObject>

- (void)scrollBarWillBeginDragging:(JYTabChangeScrollBar *)scrollBar;
- (void)scrollBarDidEndDragging:(JYTabChangeScrollBar *)scrollBar;

- (void)scrollBar:(JYTabChangeScrollBar *)scrollBar didSelectedItem:(JYScrollBarItem *)item;

@end
