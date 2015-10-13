//
//  YSHYZoomScrollView.h
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSHYZoomScrollViewDelegate <NSObject>

-(void)tapGesture;

@end

@interface YSHYZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign)id<YSHYZoomScrollViewDelegate> zoomScrolleViewDelegate;
@end
