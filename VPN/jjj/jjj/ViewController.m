//
//  ViewController.m
//  jjj
//
//  Created by 北辰青 on 2018/3/14.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import "ViewController.h"
#import "BlueToothGCDManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"hhhhhhhh");
    [[BlueToothGCDManager sharedInstance] scheduledDispatchTimerWithName:@"timerName" timeInterval:10 queue:nil repeats:YES actionOption:0 action:^{
        NSLog(@"re开始扫描 服务");
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
