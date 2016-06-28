//
//  MCADCollectionViewController.h
//  iOS_MCProject
//
//  Created by caixiaobo on 16/5/24.
//  Copyright © 2016年 caixiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

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


/*
 *显示广告的数据源，可以有6种类型 
                              0:color    （ 测试 ）
                              1:NSString，图片的网络地址，采用SDWebImage加载
                              2:NSString，本地图片文件路径
                              3:NSString，本地图片文件名
 *                            4:使用UIImage
                              5:使用UIImageData
 
 *  此属性赋值后会立即开启定时器，需要在下面两个属性设置完后再设置
 */
typedef NS_ENUM(NSInteger, MCADCollectionViewType) {
    MCADCollectionViewTypeOfColor,//背景颜色 (UIColor)
    MCADCollectionViewTypeOfURL,//图片的网络地址
    MCADCollectionViewTypeOfURLFileURL,//图片文件路径
    MCADCollectionViewTypeOfImageName,//本地图片文件名
    MCADCollectionViewTypeOfImage,//UIImage
    MCADCollectionViewTypeOfImageData//UIImageData
    
};

@interface MCADCollectionView : UIView

//必选
//图片数组类型
@property (assign, nonatomic) MCADCollectionViewType ADCV_ImageType;
//图片源
@property (nonatomic, copy) NSArray *ADCV_Data;


//可选
@property (strong, nonatomic) UICollectionView *ADCollectionView;
/**
 @brief pageConrol
 
 默认
 _ADCV_PageControl.pageIndicatorTintColor = [UIColor grayColor];
 _ADCV_PageControl.currentPageIndicatorTintColor = [UIColor redColor];
 
 */
@property (nonatomic, strong) UIPageControl *ADCV_PageControl;
//当前的index
@property (nonatomic, assign, readonly) NSInteger ADCV_CurrentPage;
//自动滚动动画时间，默认2s
@property (nonatomic, assign) NSTimeInterval ADCV_AnimationDuration;
@property (nonatomic, assign) UIEdgeInsets ADCV_ScrollViewEdge;

//返回点击当前的 Image的page
@property (nonatomic , copy) void (^tapActionBlock)(NSInteger page);

@end
