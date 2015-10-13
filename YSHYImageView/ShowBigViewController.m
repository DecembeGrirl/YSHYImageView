//
//  ShowBigViewController.m
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "ShowBigViewController.h"
#define IOS7LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation ShowImage

-(id)init
{
    if (self = [super init])
    {
        
        self.stateOfSelect = YES;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setBackgroundImage:[UIImage imageNamed:@"isSeleted"] forState:UIControlStateNormal];
        [self.button setFrame:CGRectMake(0, 0, 30, 30)];
//        [self.button addTarget:self action:@selector(cancelSelectedCurrentImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}



@end




#pragma mark - ShowBigViewController

@interface ShowBigViewController ()

@property(strong, nonatomic) NSMutableArray *imageArray;
@property(assign, nonatomic) CGPoint currentPoint;
@property (strong, nonatomic) NSMutableArray *showImageArrary;
@property (assign, nonatomic) int sendNumber;
@property (nonatomic, strong) YSHYZoomScrollView *currentZoomScrollView;
@property (nonatomic, strong) YSHYZoomScrollView * lastZoomScrollView;


@end

@implementation ShowBigViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.imageArray = [[NSMutableArray alloc]initWithCapacity:5];
    self.showImageArrary = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self initData];
    [self layOut];
}



-(void)initData
{
    for (int i = 0; i < self.arrayOK.count; i ++) {
        
        ShowImage *showImage = [[ShowImage alloc]init];
        showImage.theOrder = i;
        showImage.image = self.arrayOK[i];
        showImage.stateOfSelect = YES;
        [self.showImageArrary addObject:showImage];
    }
    ShowImage *showimage = self.showImageArrary[0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:showimage.button];
}

-(void)layOut{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollerview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(244,  _scrollerview.frame.size.height - 40, 61, 32)];
    
    _scrollerview.maximumZoomScale = 2.0;//允许放大2倍
     _scrollerview.minimumZoomScale = 0.5;//允许放大到0.5倍
    
    _scrollerview.delegate = self;
    _scrollerview.pagingEnabled = YES;
    [_scrollerview setShowsHorizontalScrollIndicator:NO];
    [_scrollerview setShowsVerticalScrollIndicator:NO];
    _scrollerview.contentSize = CGSizeMake((self.arrayOK.count) * (self.view.frame.size.width),0);
    
    _scrollerview.contentOffset = CGPointMake(0 , 0);
    _scrollerview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollerview];
    
    //显示选中的图片的大图
    for (int i=0; i<[self.showImageArrary count]; i++) {
        YSHYZoomScrollView *zoomScrollView = [[YSHYZoomScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        CGRect frame = _scrollerview.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        zoomScrollView.zoomScrolleViewDelegate = self;
        zoomScrollView.frame = frame;
        [zoomScrollView.imageView setImage:self.arrayOK[i]];
        
        
        [_scrollerview addSubview:zoomScrollView];
    }
    
    [_scrollerview setContentOffset:CGPointMake(self.view.frame.size.width *self.currentIndex, 0)];
    
    _pageControl = [[UIPageControl alloc]init];
    [_pageControl setFrame:CGRectMake(0, self.view.frame.size.height - 25, self.view.frame.size.width, 25)];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    _pageControl.numberOfPages = self.arrayOK.count;
    _pageControl.currentPage = self.currentIndex;
    [self.view addSubview:_pageControl];
    
}


#pragma  amrk - scrollViewDelegate
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.currentPoint = _scrollerview.contentOffset;
//    int a = self.currentPoint.x   / _scrollerview.frame.size.width + 1 ;
//    self.currentZoomScrollView = scrollView.subviews[a-1];
//    for (int i = 0; i < scrollView.subviews.count; i ++)
//    {
//        MRZoomScrollView * zoomScrollView = scrollView.subviews[i];
//        zoomScrollView.scrollEnabled = NO;
//    }
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPoint = _scrollerview.contentOffset;
    int b = self.currentPoint.x/_scrollerview.frame.size.width + 1 ;
    self.lastZoomScrollView = self.currentZoomScrollView;
    self.currentZoomScrollView = scrollView.subviews[b-1];
    if(![self.lastZoomScrollView isEqual:self.currentZoomScrollView])
    {
        //让滑过去的image恢复默认大小
        float newScale = self.lastZoomScrollView.minimumZoomScale;
        [self.lastZoomScrollView scrollViewDidEndZooming:self.lastZoomScrollView withView:self.lastZoomScrollView.imageView atScale:newScale];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.2 animations:^{
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        _pageControl.currentPage = index;
    } completion:nil];
    [UIView commitAnimations];
    
    
}


#pragma mark - MRZoomSCrollViewDelegate
-(void)tapGesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
