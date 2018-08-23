//
//  ViewController.m
//  仿新闻客户端Tab切换
//
//  Created by Gu,Jinyue on 2018/8/22.
//  Copyright © 2018年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "JYTabChangeScrollBar.h"

@interface ViewController ()<JYScrollBarDelegate>

@property (nonatomic, strong) JYTabChangeScrollBar *scrollBar;

@end

@implementation ViewController

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

@end
