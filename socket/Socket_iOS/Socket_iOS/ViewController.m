//
//  ViewController.m
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import "ViewController.h"

#import "OneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)one:(id)sender {
    OneViewController * one = [[OneViewController alloc]init];
    
    [self.navigationController pushViewController:one animated:YES];
}
- (IBAction)two:(id)sender {
    
}

- (IBAction)three:(id)sender {
    
}
- (IBAction)four:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
