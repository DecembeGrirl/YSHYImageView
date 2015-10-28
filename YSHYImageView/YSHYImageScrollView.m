//
//  YSHYImageScrollView.m
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "YSHYImageScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.heigh

@implementation YSHYImageScrollView
{
    NSMutableArray *imageViews;
    CGFloat cellWidth;
    CGFloat viewWidth;
    BOOL isDeleting;
}

@synthesize myScrollView,imageViews,isDeleting;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.itemCounForRw = 3;
        self.itemSpace = 5;
    }
    return self;
}
-(void)ConfigData:(NSMutableArray *)images
{
    imageViews = [NSMutableArray arrayWithCapacity:images.count];
    self.images = images;
    cellWidth = kScreenWidth / self.itemCounForRw;
    viewWidth = cellWidth - self.itemSpace;
    [self initScrollView];
    [self initViews];
}


- (void)initScrollView
{
    if (myScrollView == nil)
    {
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        myScrollView.backgroundColor = [UIColor clearColor];
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.pagingEnabled = YES;
        myScrollView.delegate = self;
        [self addSubview:myScrollView];
    }
}

- (void)initViews
{
    for (int i = 0; i < self.images.count; i++)
    {
        UIImage * image = self.images[i];;
        [self createImageViews:i withImage:image];
    }
    
    CGFloat row ;
    if(self.images.count % self.itemCounForRw)
    {
        row = self.images.count /self.itemCounForRw + 1;
    }
    else
    {
        row = self.images.count /self.itemCounForRw;
    }
    self.myScrollView.contentSize = CGSizeMake(kScreenWidth, row * cellWidth);
}

- (void)createImageViews:(NSInteger)i withImage:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setImage:image];
    
    CGFloat row = i / self.itemCounForRw;
    CGFloat col = i % self.itemCounForRw;
    imgView.frame = CGRectMake(self.itemSpace/(float)2 + cellWidth * col, row * cellWidth, viewWidth , viewWidth);
    imgView.userInteractionEnabled = YES;
    [self.myScrollView addSubview:imgView];
    [imageViews addObject:imgView];
    
    //长按删除
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    longPress.delegate = self;
    [imgView addGestureRecognizer:longPress];
    
    //点击查看大图
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapPress.delegate = self;
    [imgView addGestureRecognizer:tapPress];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setHidden:YES];
    deleteButton.frame = CGRectMake(0, 0, 25, 25);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

//长按方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        //长按开始
        isDeleting = !isDeleting;
        for (UIImageView *imageView in imageViews)
        {
            UITapGestureRecognizer * tap = imageView.gestureRecognizers[1];
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting)
            {
                //设置imageView的晃动效果
                [self Shake:imageView];
                deleteButton.hidden = NO;
                tap.enabled = NO;
            }
            else {
                deleteButton.hidden = YES;
                tap.enabled = YES;
                [UIView animateWithDuration:0.0 animations:^{
                    imageView.transform = CGAffineTransformMakeRotation(0.0);
                }];
            }
        }
    }
}

-(void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIImageView *currentImageView = (UIImageView *)recognizer.view;
    NSInteger index = [imageViews indexOfObject:currentImageView];
    [self.delegate ShowBigPicture:index];
    
}

- (void)deleteAction:(UIButton *)button
{
    isDeleting = YES;   //正处于删除状态
    UIImageView *imageView = (UIImageView *)button.superview;
    __block int index = [imageViews indexOfObject:imageView];
    [UIView animateWithDuration:0.0 animations:^{
        imageView.transform = CGAffineTransformMakeRotation(0.0);
    }];
    
    __block CGRect currentViewFrame = imageView.frame;
    __weak UIScrollView *weakScroll = myScrollView;
    UIImage *image = self.images[index];
    
    [imageView removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        for (int i = index+1 ; i < imageViews.count; i++)
        {
            UIImageView *nextImageView = imageViews[i];
            [UIView animateWithDuration:0.0 animations:^{
                nextImageView.transform = CGAffineTransformMakeRotation(0.0);
            }];
            CGRect tempRect = nextImageView.frame;
            nextImageView.frame = currentViewFrame;
            currentViewFrame = tempRect;
        }
    } completion:^(BOOL finished) {
        for (int i = index + 1; i < imageViews.count; i++)
        {
            UIImageView *otherImageView = imageViews[i];
            [self Shake:otherImageView];
        }
        [imageViews removeObject:imageView];
        [self.images removeObject:image];
        CGFloat row;
        if(self.images.count % self.itemCounForRw)
        {
            row = self.images.count /self.itemCounForRw + 1;
        }
        else
        {
            row = self.images.count /self.itemCounForRw;
        }
        weakScroll.contentSize = CGSizeMake(myScrollView.frame.size.width,row* cellWidth);
    }];
}

//设置晃动效果
-(void)Shake:(UIView *)view
{
    CGAffineTransform shake = CGAffineTransformMakeRotation(0.05);
    [UIView beginAnimations:@"quake" context:(__bridge void * _Nullable)(view)];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationDelegate:self];
    view.transform = shake;
    [UIView commitAnimations];
}


@end
