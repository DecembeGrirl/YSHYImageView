# YSHYImageView
图片显示器 点击图片进入大图查看模式 支持翻页查看 支持长按删除

导入 
#import "YSHYImageScrollView.h"
#import "ShowBigViewController.h"

并实现 YSHYImageScrollViewDelegate 中的-(void)ShowBigPicture:(NSInteger)index方法

在viewDidLoad 中实例化 YSHYImageScrollView

- (void)viewDidLoad 
{

    [super viewDidLoad];
    CGFloat coefficientHeight = self.view.frame.size.height / 670;
    yImageScrollView = [[YSHYImageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,350 *coefficientHeight)];
    yImageScrollView.delegate = self;
    [self.view addSubview:_dynamicScrollView];

    _imageArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 8; i ++) {
        UIImage *image  = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [_imageArray addObject:image];
    }
    
    [yImageScrollView ConfigData:_imageArray];
    
}


点击大图


-(void)ShowBigPicture:(NSInteger)index
{

    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    big.arrayOK = [NSMutableArray arrayWithArray:_imageArray];
    big.currentIndex = index;
    [self presentViewController:big animated:YES completion:nil];
    
}

![image](https://github.com/DecembeGrirl/YSHYImageView/blob/master/YSHYImageView/testImage/YSHYImageView.gif)

如何发现问题 欢迎大家提出来 发扬开源精神一起修改
