//
//  YSHYZoomScrollView.m
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "YSHYZoomScrollView.h"

#define ScreenWidth      [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight     [[UIScreen mainScreen]bounds].size.height

@interface YSHYZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation YSHYZoomScrollView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
    [imageView setBackgroundColor:[UIColor whiteColor]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    
    [self addSubview:imageView];
   
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapGesture:)];
    [imageView addGestureRecognizer:tapGesture];
    self.maximumZoomScale = 4.0;
}


#pragma mark - Zoom methods

-(void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self.zoomScrolleViewDelegate tapGesture];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  =  self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
     scrollView.scrollEnabled = YES;
    [scrollView setZoomScale:scale animated:NO];
}



@end
