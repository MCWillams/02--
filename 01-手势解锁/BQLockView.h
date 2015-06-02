//
//  BQLockView.h
//  01-手势解锁
//
//  Created by 严必庆 on 15-5-30.
//  Copyright (c) 2015年 严必庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQLockView;
@protocol BQLockViewDelegate <NSObject>
@optional
-(void)lockView:(BQLockView *)lockView didFinishPath:(NSString *)path;
@end
@interface BQLockView : UIView
@property (nonatomic,weak) IBOutlet id<BQLockViewDelegate>delegate;
@end
