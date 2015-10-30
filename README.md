# YSHYImageView
图片显示器 点击图片进入大图查看模式 支持翻页查看 支持长按删除并实现了晃动效果

导入 
#import "YSHYImageScrollView.h"
#import "ShowBigViewController.h"

并实现 YSHYImageScrollViewDelegate 中的-(void)ShowBigPicture:(NSInteger)index方法


在viewDidLoad 中实例化 YSHYImageScrollView


- (void)viewDidLoad 
{
     _imageScrollView = [[YSHYImageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,280)];

    _imageScrollView.delegate = self;

//    _imageScrollView.itemSpace = 10;   //设置每张图片之间的间隔  默认为5;

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


点击大图


-(void)ShowBigPicture:(NSInteger)index
{

    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    [big ConfigData:_imageArray];
    big.currentIndex = index;
    [self presentViewController:big animated:YES completion:nil];

    
}

![image](https://github.com/DecembeGrirl/YSHYImageView/blob/master/YSHYImageView/testImage/YSHYImage.gif)

如果发现问题 欢迎大家提出来 发扬开源精神一起修改
