//
//  RHSocketPacketContent.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RHSocketPacket.h"

@protocol RHSocketPacketContent <RHSocketPacket>

@property (nonatomic, readonly) NSTimeInterval timeout;

@optional

- (void)setTimeout:(NSTimeInterval)timeout;

@end  
