//
//  RHPacketHttpRequest.m
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import "RHPacketHttpRequest.h"

@implementation RHPacketHttpRequest
- (instancetype)init
{
    if (self = [super init]) {
        _requestPath = @"GET /index.html HTTP/1.1";
        _host = @"Host:www.baidu.com";
        _connection = @"Connection:close";
    }
    return self;
}

- (NSData *)data
{
    NSData *crlfData = [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding];
//    <span style="font-family: Arial, Helvetica, sans-serif;">//回车换行是http协议中每个字段的分隔符</span>
    
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendData:[_requestPath dataUsingEncoding:NSASCIIStringEncoding]];
    [packetData appendData:crlfData];
    [packetData appendData:[_host dataUsingEncoding:NSASCIIStringEncoding]];
    [packetData appendData:crlfData];
    [packetData appendData:[_connection dataUsingEncoding:NSASCIIStringEncoding]];
    [packetData appendData:crlfData];
    //    [packetData appendData:[@"Accept:image/webp,*/*;q=0.8" dataUsingEncoding:NSASCIIStringEncoding]];
    //    [packetData appendData:crlfData];
    return packetData;
}
@end
