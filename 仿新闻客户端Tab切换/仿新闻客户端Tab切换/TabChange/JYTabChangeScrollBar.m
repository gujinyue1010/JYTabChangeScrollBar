//
//  JYTabChangeScrollBar.m
//  仿新闻客户端Tab切换
//
//  Created by Gu,Jinyue on 2018/8/22.
//  Copyright © 2018年 baidu. All rights reserved.
//

#define JYScrollBarItemNormalColor      [UIColor blackColor]
#define JYScrollBarItemSelectedColor    [UIColor blueColor]

#define JYScrollBarItemNormalFont   [UIFont systemFontOfSize:14]
#define JYScrollBarItemSelectedFont [UIFont systemFontOfSize:18]

#define JYScrollBarItemIndicatorColor [UIColor grayColor]

#import "JYTabChangeScrollBar.h"

@implementation JYScrollBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
  
    }
    return self;
}

@end

@interface JYTabChangeScrollBar() <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    CALayer *_indicatorLayer; // 下划线
}

@end

@implementation JYTabChangeScrollBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _selectedItemIndex = -1;
        
        // 下划线默认显示, 高度是1, 颜色是灰色
        _showActiveIndicator = YES;
        _indicatorHeight = 1;
        _indicatorColor = JYScrollBarItemIndicatorColor;
        
        // item默认字体颜色和字体大小
        _normalColor   = JYScrollBarItemNormalColor;
        _selectedColor = JYScrollBarItemSelectedColor;
        _normalFont    = JYScrollBarItemNormalFont;
        _selectedFont  = JYScrollBarItemSelectedFont;
    }
    return self;
}

#pragma mark - Public Methods

+ (NSArray<JYScrollBarItem *> *)itemsWithTextArray:(NSArray<NSString *> *)textArray {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:textArray.count];
    [textArray enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[self itemWithText:text]];
    }];
    return items;
}

+ (JYScrollBarItem *)itemWithText:(NSString *)text {
    JYScrollBarItem *item = [[JYScrollBarItem alloc] initWithFrame:CGRectZero];
    [item setTitle:text forState:UIControlStateNormal];
    [item setTitle:text forState:UIControlStateSelected];
//    [item setTitleColor:JYScrollBarItemNormalColor   forState:UIControlStateNormal];
//    [item setTitleColor:JYScrollBarItemSelectedColor forState:UIControlStateSelected];
//    item.titleLabel.font = JYScrollBarItemNormalFont;
    return item;
}

#pragma mark - Setter

- (void)setItems:(NSArray<JYScrollBarItem *> *)items {
    if (items.count == 0) {
        return;
    }
    
    _items = items;
    
    for (JYScrollBarItem *item in items) {
        [item addTarget:self action:@selector(didItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitleColor:_normalColor   forState:UIControlStateNormal];
        [item setTitleColor:_selectedColor forState:UIControlStateSelected];
        item.titleLabel.font = _normalFont;
        [_scrollView addSubview:item];
    }
    
    [self updateUI];
    [self updateIndicatorLayer];
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    if (_selectedItemIndex == selectedItemIndex) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [_items enumerateObjectsUsingBlock:^(JYScrollBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectedItemIndex == idx) {
            __strong __typeof(weakSelf) self = weakSelf;
            [self selectItem:item animate:NO];
            *stop = YES;
        }
    }];
}

#pragma mark - Private Methods

/**
 * 根据items内容计算最终的UI展示
 */
- (void)updateUI {
    if (_items.count == 0) {
        return;
    }
    
    CGSize size = CGSizeMake(self.bounds.size.width - 2 * _edgeDistance, self.bounds.size.height);
    _scrollView.frame = CGRectMake(_edgeDistance, 0, size.width, size.height);
    
    CGFloat contentWidth = 0;
    CGFloat contentHeight = CGRectGetHeight(self.bounds);
    for (JYScrollBarItem *item in _items) {
        @autoreleasepool {
            CGSize itemSize = [item sizeThatFits:size];
            CGFloat x = contentWidth;
            CGFloat y = (contentHeight - itemSize.height) / 2.0;
            CGFloat w = itemSize.width + _itemSpacing;
            item.frame = CGRectMake(x, y, w, itemSize.height);

            contentWidth += w;
        }
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    _scrollView.contentOffset = CGPointZero;
    
    // 默认选中第一个
    [self setSelectedItemIndex:0];
}

/**
 * 展示下划线
 */
- (void)updateIndicatorLayer {
    if (!_showActiveIndicator) {
        return;
    }
    
    CGRect selectedItemFrame = self.selectedItem.frame;
    CGFloat h = _indicatorHeight;
    CGFloat w = CGRectGetWidth(selectedItemFrame) - _itemSpacing / 2;
    CGFloat x = CGRectGetMidX(selectedItemFrame) - w / 2;
    CGFloat y = CGRectGetMidY(selectedItemFrame) + CGRectGetHeight(selectedItemFrame) / 2;
    if (!_indicatorLayer) {
        _indicatorLayer = [CALayer layer];
        _indicatorLayer.backgroundColor = _indicatorColor.CGColor;
        [_scrollView.layer addSublayer:_indicatorLayer];
    }
    
    _indicatorLayer.frame = CGRectMake(x, y, w, h);
}

/**
 * JYScrollBarItem的点击事件
 */
- (void)didItemClicked:(JYScrollBarItem *)item {
    if (item.selected) {
        return;
    }
    [self selectItem:item animate:YES];
}

/**
 * 选中某个Item
 * param item    选中的item
 * param animate 是否需要选中动画
 */
- (void)selectItem:(JYScrollBarItem *)item animate:(BOOL)animate {
    item.selected = YES;
    item.titleLabel.font = _selectedFont;
    
    if (_selectedItemIndex >= 0 && _selectedItemIndex < _items.count) {
        JYScrollBarItem *lastSelectedItem = [_items objectAtIndex:_selectedItemIndex];
        lastSelectedItem.selected = NO;
        lastSelectedItem.titleLabel.font = _normalFont;
    }
    
    _selectedItemIndex = [_items indexOfObject:item];
    _selectedItem = item;
    
    [self updateItemPositionWithAnimation:YES];
    [self updateIndicatorLayer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollBar:didSelectedItem:)]) {
        [self.delegate scrollBar:self didSelectedItem:item];
    }
}

/**
 * 被选中的Item自动滚动
 */
- (void)updateItemPositionWithAnimation:(BOOL)animate {
    if (CGRectGetWidth(self.frame) == 0) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    CGFloat min = 0;
    CGFloat max = _scrollView.contentSize.width - width;
    if (min > max) {
        return;
    }
    CGFloat xOffset = CGRectGetMidX(_selectedItem.frame) - width / 2;
    
    [_scrollView setContentOffset:CGPointMake(MAX(MIN(max, xOffset), min), 0) animated:animate];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollBarWillBeginDragging:)]) {
        [self.delegate scrollBarWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollBarDidEndDragging:)]) {
        [self.delegate scrollBarDidEndDragging:self];
    }
}

@end
