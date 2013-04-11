//
//  ViewController.h
//  CatchSiky
//
//  Created by 张 烈镇 on 13-3-25.
//  Copyright (c) 2013年 mobadcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIButton *btnSiky;
@property (nonatomic, retain) UILabel *lblStatus;
@property (nonatomic, assign) int counter_ok;
@property (nonatomic, assign) int counter_miss;
@property (nonatomic, assign) BOOL isGameover;

@end
