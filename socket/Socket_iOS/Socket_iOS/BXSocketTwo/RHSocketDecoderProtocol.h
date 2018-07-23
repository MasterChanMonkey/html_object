//
//  RHSocketDecoderProtocol.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RHSocketPacketContent.h"

@protocol RHSocketDecoderOutputDelegate <NSObject>

@required

- (void)didDecode:(id<RHSocketPacketContent>)packet tag:(NSInteger)tag;

@end

@protocol RHSocketDecoderProtocol <NSObject>

@required

- (NSUInteger)decodeData:(NSData *)data decoderOutput:(id<RHSocketDecoderOutputDelegate>)output tag:(long)tag;//这里有返回值，是了为了处理数据包拼包

@end  
