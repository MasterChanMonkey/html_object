//
//  AManager.m
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/2.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import "AManager.h"
@interface AManager()
@property(nonatomic,weak)Bdelegate * b;
@end
@implementation AManager
+(AManager*)manager
{
    AManager * a = [[AManager alloc]init];
    Bdelegate * b = [[Bdelegate alloc]init];
    a.b = b;
    
    return a;
}

-(void)click
{
   
//    [b setString:@"hhhh"];
    if (self.b.block) {
        self.b.block(@"1111");
    }
    
    
}
-(void)GetBlock:(BdelegateBlock)block
{
    if (block) {
        self.b.block = ^(NSString *str) {
            
            block(str);
        };
    }
}

@end
