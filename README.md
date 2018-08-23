# JYTabChangeScrollBar
仿目前主流新闻客户端顶部Tab切换效果

1. 封装了一个高度自由的JYTabChangeScrollBar。
   * 外部只需要传入需要展示的Tab文字数组即可出现效果。
   * 外部可以得到当前选中的item和当前选中Item的index。
   * 外部可以自由定义scrollBar的左右间距。
   * 外部可以自由定义scrollBar的item之间的间距, 如果不设置则为0。
   * 外部可以自由定义scrollBar的item的字体大小和颜色, 如果不设置则显示默认值。
   * 外部可以自由定义scrollBar的下划线属性, 包括是否可以展示下划线, 下划线的高度和颜色。如果不设置则显示默认值
   * 外部可以实现scrollBar的代理来得到scrollBar将要拖拽、拖拽完成以及选中某个item的回调。
   
   ~~~
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

// item字体颜色和大小(有默认值, 外部可自定义传入)
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont  *normalFont;
@property (nonatomic, strong) UIFont  *selectedFont;

// 是否显示下划线
@property (nonatomic, assign) BOOL showActiveIndicator;
// 下划线高度
@property (nonatomic, assign) CGFloat indicatorHeight;
// 下划线颜色
@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, weak) id<JYScrollBarDelegate> delegate;

// 根据传入的文字生成Item数组
+ (NSArray<JYScrollBarItem *> *)itemsWithTextArray:(NSArray<NSString *> *)textArray;

@end

#pragma mark - JYScrollBarDelegate

@protocol JYScrollBarDelegate <NSObject>

- (void)scrollBarWillBeginDragging:(JYTabChangeScrollBar *)scrollBar;
- (void)scrollBarDidEndDragging:(JYTabChangeScrollBar *)scrollBar;

   ~~~

