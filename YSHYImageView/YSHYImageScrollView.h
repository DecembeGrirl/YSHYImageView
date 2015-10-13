//
//  YSHYImageScrollView.h
//  YSHYImageView
//
//  Created by 杨淑园 on 15/10/13.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSHYImageScrollViewDelegate <NSObject>

-(void)ShowBigPicture:(NSInteger)index;

@end

@interface YSHYImageScrollView : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *myScrollView;

@property(nonatomic,retain)NSMutableArray *images;

@property(nonatomic,retain)NSMutableArray *imageViews;

@property(nonatomic,assign)BOOL isDeleting;

@property (nonatomic, assign)id<YSHYImageScrollViewDelegate> delegate;

-(void)ConfigData:(NSMutableArray *)images;

@end
