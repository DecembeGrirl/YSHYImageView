//
//  ViewController.m
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "ViewController.h"
#import "YSHYImageScrollView.h"
#import "ShowBigViewController.h"
@interface ViewController ()<YSHYImageScrollViewDelegate>
{
    YSHYImageScrollView *_imageScrollView;
    NSMutableArray * _imageArray;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageScrollView = [[YSHYImageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,280)];
    _imageScrollView.delegate = self;
//    _imageScrollView.itemSpace = 10; //设置每张图片之间的间隔  默认为5;
//    _imageScrollView.itemCounForRw = 5; //设置每行的图片数量  默认为3;
    [self.view addSubview:_imageScrollView];

    _imageArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 8; i ++)
    {
        UIImage *image  = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [_imageArray addObject:image];
    }
    [_imageScrollView ConfigData:_imageArray];
}


-(void)ShowBigPicture:(NSInteger)index
{
    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    [big ConfigData:_imageArray];
    big.currentIndex = index;
    [self presentViewController:big animated:YES completion:nil];

}

@end
