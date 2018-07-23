//
//  RHSocketService.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHSocketEncoderProtocol.h"
#import "RHSocketDecoderProtocol.h"

extern NSString *const kNotificationSocketServiceState;
extern NSString *const kNotificationSocketPacketRequest;
extern NSString *const kNotificationSocketPacketResponse;

@interface RHSocketService : NSObject <RHSocketEncoderOutputDelegate, RHSocketDecoderOutputDelegate>

@property (nonatomic, copy) NSString *serverHost;
@property (nonatomic, assign) int serverPort;

@property (nonatomic, strong) id<RHSocketEncoderProtocol> encoder;
@property (nonatomic, strong) id<RHSocketDecoderProtocol> decoder;

@property (assign, readonly) BOOL isRunning;

+ (instancetype)sharedInstance;

- (void)startServiceWithHost:(NSString *)host port:(int)port;
- (void)stopService;

- (void)asyncSendPacket:(id<RHSocketPacketContent>)packet;

@end
