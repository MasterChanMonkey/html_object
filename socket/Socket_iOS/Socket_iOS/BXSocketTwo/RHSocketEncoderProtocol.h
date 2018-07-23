//
//  RHSocketEncoderProtocol.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RHSocketPacketContent.h"

@protocol RHSocketEncoderOutputDelegate <NSObject>

@required

- (void)didEncode:(NSData *)data timeout:(NSTimeInterval)timeout tag:(NSInteger)tag;

@end

@protocol RHSocketEncoderProtocol <NSObject>

@required

- (void)encodePacket:(id<RHSocketPacketContent>)packet encoderOutput:(id<RHSocketEncoderOutputDelegate>)output;

@end  
