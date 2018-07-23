//
//  AManager.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/2.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bdelegate.h"
@interface AManager : NSObject
+(AManager*)manager;
-(void)click;
-(void)GetBlock:(BdelegateBlock)block;
@end
