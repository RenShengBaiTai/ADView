# github

自己分装的广告轮播控件

原因：原来一直用UIScrollView来写，最近感觉这样写不太好，如果广告数量多了以后，都不释放内存，不合理；

想法：想套用UITableview懒加载的思路，只显示当前屏幕的内容，所以就用UICollectView分装了这个；

【注】1.这是个人想法，欢迎大神们指正！2.代码还是初成，欢迎大神们指正！共同进步！

使用方法：

/**
 @brief 使用方法
 
 MCADCollectionView *adCollection = [[MCADCollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
 
 adCollection.ADCV_ImageType = MCADCollectionViewTypeOfColor;
 
 ============================
 
 中间添加一些参数的设置

 =========================
 
 最后再加数据源，应为重写了set方法，会调用 reloadData方法，这样比较合理
 
 adCollection.ADCV_Data = @[[UIColor blackColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor]];

 或则是：
 adCollection.ADCV_Data = @[@"LaunchImage",@""];
 [self.view addSubview:adCollection];

 //点击cell相应方法
 [adCollection setTapActionBlock:^(NSInteger page) {
 
 NSLog(@"%ld",page);
 }];
 
 */
