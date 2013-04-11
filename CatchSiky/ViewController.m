//
//  ViewController.m
//  CatchSiky
//
//  Created by 张 烈镇 on 13-3-25.
//  Copyright (c) 2013年 mobadcloud. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define THIS_SIKY_WIDTH 100
#define THIS_SIKY_HEIGHT 100
#define THIS_MAXCOUNT 3
#define THIS_SOUND_FILE @"catched.wav"
static int catch_count = 0;

@interface ViewController ()

@end

@implementation ViewController
@synthesize timer = _timer;
@synthesize btnSiky = _btnSiky;
@synthesize lblStatus = _lblStatus;

@synthesize counter_ok = _counter_ok;
@synthesize counter_miss = _counter_miss;

@synthesize isGameover = _isGameover;


- (void)testCode
{
    //浏览Documents目录 下所有指定扩展名的文件
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"  ];
    NSArray *arr_files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    
    
}

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self drawUI];
    
    [self initData];
    

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doReplay)];
    [tgr setNumberOfTapsRequired:1];
    [tgr setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:tgr];
    [tgr release];
    
    
}



- (void)initData
{
    catch_count   = 0;
    _counter_miss = 0;
    _counter_ok   = 0;
    _isGameover   = NO;

}

- (void)doReplay
{
    NSLog(@"replay start!");
    [self initData];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doChangeSiky) userInfo:nil repeats:YES];
    
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Tap recognizer received!");
    [self initData];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doChangeSiky) userInfo:nil repeats:YES];
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"Swipe recognizer received!");
}

- (void)drawUI
{
    self.btnSiky = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSiky setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [_btnSiky setImage:[UIImage imageNamed:@"0.png"] forState:UIControlStateHighlighted];
    [_btnSiky setFrame:[self getRandomFrame]];
    [_btnSiky addTarget: self action:@selector(doCatchSiky:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnSiky];
    
    self.lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)   ];
    [self.view addSubview:_lblStatus];
    [_lblStatus setTextAlignment:NSTextAlignmentCenter];
    [_lblStatus setFont:[UIFont systemFontOfSize:12.0f]];
    [_lblStatus setTextColor:[UIColor whiteColor]];
    [_lblStatus setBackgroundColor:[UIColor clearColor]];
    
    [_lblStatus release];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doChangeSiky) userInfo:nil repeats:YES];
    

}

- (CGRect)getRandomFrame
{
   
    
    int i_width  = self.view.frame.size.width  - THIS_SIKY_WIDTH;
    int i_height = self.view.frame.size.height - THIS_SIKY_HEIGHT;
    
    CGRect rect = CGRectMake(arc4random() % i_width,
                             arc4random() % i_height,
                             THIS_SIKY_WIDTH,
                             THIS_SIKY_HEIGHT  );
    return rect;
                       
}

- (void)doShowSelectItem
{
    // show UIAlertView / UIActionSheet
    NSString *message =  [NSString stringWithFormat:@"Ok:%d Miss:%d\n Play Again?", _counter_ok, _counter_miss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Result:" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Replay", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Replay"])
    {
        [self doReplay];
        NSLog(@"Replay it,haha");
    }
}

- (void)doChangeSiky
{
    if (catch_count++  >= THIS_MAXCOUNT)
    {
        self.isGameover = YES;
    }
    
    if (self.isGameover)
    {
        [_timer invalidate] ;
        NSLog(@"timer invalid!");
        
        [self doShowSelectItem];
        return;
    }
    
    
    
    _counter_miss = catch_count - _counter_ok;
    
    [_lblStatus setText:[NSString stringWithFormat:@"%d / %d ok:%d miss:%d", catch_count, THIS_MAXCOUNT, _counter_ok, _counter_miss]];

    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.01f animations:nil];
    [_btnSiky setFrame:[self getRandomFrame]];
    
    [_btnSiky setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",arc4random() %2]] forState:UIControlStateNormal];
    [UIView commitAnimations];
    
    
    
}

- (void)doCatchSiky:(id)sender
{
    if (!self.isGameover)
    {
        _counter_ok ++;
        [self doPlaySound];
    }
}

- (void)doPlaySound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:THIS_SOUND_FILE ofType:nil];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath] , &soundId);
    AudioServicesPlayAlertSound(soundId);
    //上、下 两条语句的区别 alert 当系统静音会切至震动，而play时如果系统静音则不会发声
    //AudioServicesPlaySystemSound(soundId);
    //在这里释放掉，则不发声
    //AudioServicesDisposeSystemSoundID(soundId);
    
    // 如果震动就更简单了，只需要下面一句
    // AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)dealloc
{
    [_lblStatus release];
    _lblStatus = nil;
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
