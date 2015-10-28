//
//  ShowBigViewController.h
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "YSHYZoomScrollView.h"

#pragma mark - showImage

@interface ShowImage : NSObject

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) bool stateOfSelect;
@property (strong, nonatomic) UIButton * button;
@property (assign, nonatomic) int theOrder;
@end

#pragma mark - ShowBigViewController
@interface ShowBigViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,YSHYZoomScrollViewDelegate>
{
    UIScrollView    *_scrollerview;
    UIPageControl  *_pageControl;
    NSMutableArray *_bigImageArray;
}

@property (nonatomic, assign)NSInteger currentIndex;
-(void)ConfigData:(NSArray *)array;

@end




