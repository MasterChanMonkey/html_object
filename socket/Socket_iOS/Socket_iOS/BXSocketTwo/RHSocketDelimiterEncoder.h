//
//  RHSocketDelimiterEncoder.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHSocketEncoderProtocol.h"

/**
 *  针对数据包分隔符编码器
 *  默认数据包中每帧最大值为8192（maxFrameSize == 8192）
 *  默认数据包每帧分隔符为0xff（delimiter == 0xff）
 */
@interface RHSocketDelimiterEncoder : NSObject <RHSocketEncoderProtocol>

@property (nonatomic, assign) NSUInteger maxFrameSize;
@property (nonatomic, assign) uint8_t delimiter;

@end
