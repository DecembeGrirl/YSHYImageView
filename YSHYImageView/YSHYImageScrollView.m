//
//  YSHYImageScrollView.m
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "YSHYImageScrollView.h"
#define itemCounForRw 3

@implementation YSHYImageScrollView
{
    float ScreenWidth;
    float ScreenHeight;
    NSMutableArray *imageViews;
    float singleWidth;
    BOOL isDeleting;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

@synthesize myScrollView,imageViews,isDeleting;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        UIScreen *screen = [UIScreen mainScreen];
        ScreenWidth = screen.bounds.size.width;
        ScreenHeight = screen.bounds.size.height;
           }
    return self;
}
-(void)ConfigData:(NSMutableArray *)images
{
    imageViews = [NSMutableArray arrayWithCapacity:images.count];
    self.images = images;
    singleWidth = ScreenWidth / itemCounForRw;
    //创建底部滑动视图
    [self _initScrollView];
    [self _initViews];
}


- (void)_initScrollView
{
    if (myScrollView == nil) {
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        myScrollView.backgroundColor = [UIColor clearColor];
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.pagingEnabled = YES;
        myScrollView.delegate = self;
        [self addSubview:myScrollView];
        
    }
}

- (void)_initViews
{
    for (int i = 0; i < self.images.count; i++) {
        UIImage * image = self.images[i];;
        [self createImageViews:i withImage:image];
    }
    
    int row;
    if(self.images.count % itemCounForRw)
    {
        row = self.images.count /itemCounForRw + 1;
    }
    else
    {
        row = self.images.count /itemCounForRw;
    }
    self.myScrollView.contentSize = CGSizeMake(ScreenWidth, row* singleWidth);
}

- (void)createImageViews:(NSInteger)i withImage:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setImage:image];
    
    int row = i / itemCounForRw;
    int col = i % itemCounForRw;
    imgView.frame = CGRectMake(singleWidth * col, row * singleWidth, singleWidth, singleWidth);
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
    if (isDeleting) {
        [deleteButton setHidden:NO];
    } else {
        [deleteButton setHidden:YES];
    }
    deleteButton.frame = CGRectMake(0, 0, 25, 25);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

//长按方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //长按开始
        startPoint = [recognizer locationInView:recognizer.view];
        originPoint = imageView.center;
        isDeleting = !isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        for (UIImageView *imageView in imageViews) {
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //长按移动
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        imageView.center = CGPointMake(imageView.center.x + deltaX, imageView.center.y + deltaY);
        NSInteger index = [self indexOfPoint:imageView.center withView:imageView];
        if (index < 0) {
            isContain = NO;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint temp = CGPointZero;
                UIImageView *currentImagView = imageViews[index];
                NSInteger idx = [imageViews indexOfObject:imageView];
                temp = currentImagView.center;
                currentImagView.center = originPoint;
                imageView.center = temp;
                originPoint = imageView.center;
                isContain = YES;
                [imageViews exchangeObjectAtIndex:idx withObjectAtIndex:index];
            } completion:^(BOOL finished) {
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //长按结束
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformIdentity;
            if (!isContain) {
                imageView.center = originPoint;
            }
        }];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)recognizer
{
   UIImageView *currentImageView = (UIImageView *)recognizer.view;
    NSInteger index = [imageViews indexOfObject:currentImageView];
    [self.delegate ShowBigPicture:index];
    
}


//获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view
{
    UIImageView *originImageView = (UIImageView *)view;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *otherImageView = imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

- (void)deleteAction:(UIButton *)button
{
    isDeleting = YES;   //正处于删除状态
    UIImageView *imageView = (UIImageView *)button.superview;
    __block int index = [imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = myScrollView;
    UIImage *image = self.images[index];
    [UIView animateWithDuration:0.1 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            for (int i = index + 1; i < imageViews.count; i++) {
                UIImageView *otherImageView = imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [imageViews removeObject:imageView];
            [self.images removeObject:image];
                weakScroll.contentSize = CGSizeMake(myScrollView.frame.size.width,(self.images.count/2 + self.imageViews.count %2)* singleWidth);
        }];
    }];
}




@end
