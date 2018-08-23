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

   - (void)scrollBar:(JYTabChangeScrollBar *)scrollBar didSelectedItem:(JYScrollBarItem *)item;

   @end
   ~~~
   
2. 外部使用非常简单
   ~~~
   - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *textArray = @[@"推荐", @"新时代", @"科技", @"体育", @"亚运会会", @"懂车帝", @"房产", @"小说", @"动漫"];
    NSArray *items = [JYTabChangeScrollBar itemsWithTextArray:textArray];
    [self.scrollBar setItems:items];
    
    // 默认选中第一个, 可以自己设置默认选中第几个
    //[self.scrollBar setSelectedItemIndex:3];
   }

   #pragma mark - JYScrollBarDelegate

   - (void)scrollBarWillBeginDragging:(JYTabChangeScrollBar *)scrollBar {
       NSLog(@"gjy--开始拖拽");
   }

   - (void)scrollBarDidEndDragging:(JYTabChangeScrollBar *)scrollBar {
       NSLog(@"gjy--结束拖拽");
   }

   - (void)scrollBar:(JYTabChangeScrollBar *)scrollBar didSelectedItem:(JYScrollBarItem *)item {
       NSLog(@"gjy--选中:%@ 是第%ld个Item", item.titleLabel.text, scrollBar.selectedItemIndex + 1);
   }

   #pragma mark - Getter

   - (JYTabChangeScrollBar *)scrollBar {
       if (!_scrollBar) {
           _scrollBar = [[JYTabChangeScrollBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
           _scrollBar.backgroundColor = [UIColor greenColor];
           _scrollBar.edgeDistance = 10;
           _scrollBar.itemSpacing = 25;
        
           //_scrollBar.showActiveIndicator = NO; // 控制下划线是否显示,默认YES
           //_scrollBar.indicatorHeight = 3;      // 控制下划线高度, 默认是1
           //_scrollBar.indicatorColor = [UIColor redColor]; // 控制下划线颜色, 默认是灰色
        
           // 控制item字体颜色和字体大小
           //_scrollBar.normalFont    = [UIFont systemFontOfSize:12.0];
           //_scrollBar.selectedFont  = [UIFont systemFontOfSize:14.0];
           //_scrollBar.normalColor   = [UIColor orangeColor];
           //_scrollBar.selectedColor = [UIColor redColor];
        
           _scrollBar.delegate = self;
           [self.view addSubview:_scrollBar];
       }
       return _scrollBar;
   }
   ~~~

3. 最终效果gif图

    ![img](https://github.com/gujinyue1010/JYTabChangeScrollBar/blob/master/1.gif)
