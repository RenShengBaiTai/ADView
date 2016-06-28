//
//  MCADCollectionViewController.m
//  iOS_MCProject
//
//  Created by caixiaobo on 16/5/24.
//  Copyright © 2016年 caixiaobo. All rights reserved.
//

#import "MCADCollectionView.h"
#import "NSTimer+MCCategory.h"

@interface MCADCollectionView()<

    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

//timer
@property (nonatomic, strong) NSTimer *timer;
//真正的数据源
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

static NSString *cellID = @"cellID";

@implementation MCADCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self initData];
        [self setupCollectionView];
        self.ADCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(_ADCV_CurrentPage +1), 0);
    }
    return self;
}

static NSString *dataKey = @"dataKey";
static NSString *tapActionKey = @"tapActionKey";
#pragma mark - setter
-(void)setADCV_Data:(NSArray *)ADCV_Data
{
    _ADCV_CurrentPage = 0;
    
    if (ADCV_Data.count > 1) {
        
        _ADCV_Data = ADCV_Data;
        if (![_timer isValid]) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:_ADCV_AnimationDuration target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
            [_timer pauseTimer];
        }
        [_timer resumeTimerAfterTimeInterval:_ADCV_AnimationDuration];
        
        self.pageControl.numberOfPages = ADCV_Data.count;
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
        
        //处理数据
        //为了实现无限循环滚动
        //例如有3张图片，必须有五个页面：排列的顺序是：2-0-1-2-0
        for (int i = 0; i < ADCV_Data.count; i++) {
            
            if (i == 0) {
                
                NSDictionary *dic = @{tapActionKey:@(ADCV_Data.count - 1),dataKey:ADCV_Data[ADCV_Data.count - 1]};
                [_dataArr addObject:dic];
            }
            NSDictionary *dic = @{tapActionKey:@(i),dataKey:ADCV_Data[i]};
            [_dataArr addObject:dic];
            
            if (i == ADCV_Data.count - 1) {
                
                NSDictionary *dic = @{tapActionKey:@(0),dataKey:ADCV_Data[0]};
                [_dataArr addObject:dic];
            }
        }
        
        [self.ADCollectionView reloadData];
    }
}

-(void)setADCV_ScrollViewEdge:(UIEdgeInsets)ADCV_ScrollViewEdge
{
    _ADCV_ScrollViewEdge = ADCV_ScrollViewEdge;
    self.ADCollectionView.contentInset = ADCV_ScrollViewEdge;
}

#pragma mark - UI
- (UIPageControl*)pageControl
{
    if (!_ADCV_PageControl) {
        CGRect rect = CGRectMake(0, CGRectGetHeight(self.frame) -10, CGRectGetWidth(self.frame), 10);
        _ADCV_PageControl = [[UIPageControl alloc]initWithFrame:rect];
        _ADCV_PageControl.hidesForSinglePage = YES;
        _ADCV_PageControl.pageIndicatorTintColor = [UIColor grayColor];
        _ADCV_PageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:_ADCV_PageControl];
    }
    return _ADCV_PageControl;
}

- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.ADCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.ADCollectionView.backgroundColor = [UIColor whiteColor];
    self.ADCollectionView.delegate = self;
    self.ADCollectionView.dataSource = self;
    self.ADCollectionView.scrollsToTop = NO;
    self.ADCollectionView.showsHorizontalScrollIndicator = NO;
    self.ADCollectionView.pagingEnabled = YES;
    [self.ADCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:self.ADCollectionView];
}

#pragma mark - initData
- (void)initData{
    
    _ADCV_AnimationDuration = 2.0f;
    _dataArr = [NSMutableArray array];
}

#pragma mark - Action
-(void)onTimer:(NSTimer*)timer
{
    //当到了滚动的时间：只会向下滚动，说以，只能++
    _ADCV_CurrentPage ++;
    if (_ADCV_CurrentPage > (_ADCV_Data.count - 1)) {
        
        _ADCV_CurrentPage = 0;
    }
    //因为排列的问题，想移动到当前的页面位置，必须 +1
    self.ADCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(_ADCV_CurrentPage +1), 0);
    _ADCV_PageControl.currentPage = _ADCV_CurrentPage;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始滚动时暂停定时器
    [self.timer pauseTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];
    //滚动结束回复定时器
    [self.timer resumeTimerAfterTimeInterval:_ADCV_AnimationDuration];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];
}

-(void)refreshCurrentPage
{
    CGFloat pageIndex = self.ADCollectionView.contentOffset.x / CGRectGetWidth(self.frame);
    
    //因为是 page 的原因，self.collectionView.contentOffset.x 只会是屏幕宽度的整数倍
    //所以滚动到下一张            （>）;  _currentPage ++
    //上一张                    （<）;  _currentPage --
    //没有划出屏幕的 1/2 ，屏幕不变（=）;  _currentPage 不变
    if (pageIndex - (_ADCV_CurrentPage +1) > 0) {
        
        _ADCV_CurrentPage ++;
    }else if(pageIndex - (_ADCV_CurrentPage +1) < 0){
        _ADCV_CurrentPage--;
    }
    
    //滚动到 第1张，需要加载最后一张
    if (_ADCV_CurrentPage < 0) {
        
        _ADCV_CurrentPage = self.ADCV_Data.count-1;
        self.ADCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(_ADCV_CurrentPage +1), 0);
    }
    //滚动到最后一张，需要加载第一张
    if (_ADCV_CurrentPage > self.ADCV_Data.count-1) {
        
        _ADCV_CurrentPage = 0;
        self.ADCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(_ADCV_CurrentPage +1), 0);
    }
    
    self.ADCV_PageControl.currentPage = _ADCV_CurrentPage;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.backgroundColor = [UIColor blueColor];
    switch (_ADCV_ImageType) {
        case MCADCollectionViewTypeOfURL:
            
            //这里我用的是 sdImage库，如果想用先导入库
//            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.item][dataKey]] placeholderImage:[UIImage imageNamed:@""]];
            break;
        case MCADCollectionViewTypeOfURLFileURL:
        {
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:_dataArr[indexPath.item][dataKey]];
            imageView.image = image;
        }
            break;
        case MCADCollectionViewTypeOfImageName:
        {
            UIImage *image = [UIImage imageNamed:_dataArr[indexPath.item][dataKey]];
            imageView.image = image;
        }
            break;
        case MCADCollectionViewTypeOfImage:
            
            imageView.image = _dataArr[indexPath.item][dataKey];
            break;
        case MCADCollectionViewTypeOfImageData:
        {
            UIImage *image = [UIImage imageWithData:_dataArr[indexPath.item][dataKey]];
            imageView.image = image;
        }
            break;
        default:
        {
            imageView.backgroundColor = _dataArr[indexPath.item][dataKey];
        }
            break;
    }
    cell.backgroundView = imageView;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_tapActionBlock) {
        
        NSInteger tapAction = [_dataArr[indexPath.item][tapActionKey] integerValue];
        _tapActionBlock(tapAction);
    }
}

@end
