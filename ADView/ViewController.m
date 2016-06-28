//
//  ViewController.m
//  ADView
//
//  Created by caixiaobo on 16/6/16.
//  Copyright © 2016年 caixiaobo. All rights reserved.
//

#import "ViewController.h"
#import "MCADCollectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    MCADCollectionView *adCollection = [[MCADCollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    adCollection.ADCV_ImageType = MCADCollectionViewTypeOfColor;
    adCollection.ADCV_Data = @[[UIColor blackColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor]];
    [self.view addSubview:adCollection];
    [adCollection setTapActionBlock:^(NSInteger page) {
        
        NSLog(@"%ld",page);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
