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
    YSHYImageScrollView *_dynamicScrollView;
    NSMutableArray * _imageArray;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    CGFloat coefficientHeight = self.view.frame.size.height / 670;
    
    _dynamicScrollView = [[YSHYImageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,350 *coefficientHeight)];
    _dynamicScrollView.delegate = self;
    [self.view addSubview:_dynamicScrollView];

    
    _imageArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 8; i ++) {
        
        UIImage *image  = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [_imageArray addObject:image];
    }
    
    [_dynamicScrollView ConfigData:_imageArray];
    

    
}


-(void)ShowBigPicture:(NSInteger)index
{
    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    big.arrayOK = [NSMutableArray arrayWithArray:_imageArray];
    big.currentIndex = index;
    [self presentViewController:big animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
