CocoaAsyncSocket 网络通信使用之http协议测试（三）




通过前一篇CocoaAsyncSocket网络通信使用之数据编码和解码（二），我们已经搭建好了socket的框架。

框架主要分为以下5个模块：

1-网络连接模块（socket connection）

2-数据协议框架（socket packet content protocol）

3-发送数据前的编码模块（socket encoder protocol）

4-接收数据后的解码模块（socket decoder protocol）

5-各模块的组合调用（socket service）


简述：

通过5个模块的协同工作，可以方便的处理tcp通信的扩展。

因为不方便公开外网服务，不能很好的测试自定义协议的编码器／解码器，

只是简单的对网络连接成功做了打印，现在我们来实践下框架的扩展用法。



http（HyperText Transport Protocol，超文本传输协议）

其实现在网上随处可见http协议的服务，而http是基于tcp／ip的，我们正好可以借用http来实践我们的用法。

现在就针对http协议来实现我们的编码器／解码器。



http协议内容很多，本文主要是测试sokcet框架，确认框架的完整性，拓展性，具体协议内容请自行搜索（http协议格式）。

以下是实现编码器／解码器时，学习的网址：（强烈建议学习一下，否则不好理解http编码器／解码器的内容哦）

http://blog.csdn.net/gueter/article/details/1524447


http协议的测试［编码器／解码器］

代码中只是测试用例，并非真实完整实现，看官勿喷。


RHPacketHttpRequest.h文件：（http协议的测试请求包）

[objc] view plain copy
#import "RHPacketBody.h"

@interface RHPacketHttpRequest : RHPacketBody

@property (nonatomic, copy) NSString *requestPath;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *connection;

@end

RHPacketHttpRequest.m文件：（只是测试，默认写了几个请求参数）

[objc] view plain copy
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
NSData *crlfData = [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding];<span style="font-family: Arial, Helvetica, sans-serif;">//回车换行是http协议中每个字段的分隔符</span>

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


RHSocketHttpEncoder.h文件：（http协议的测试编码器）

[objc] view plain copy
#import <Foundation/Foundation.h>
#import "RHSocketEncoderProtocol.h"

@interface RHSocketHttpEncoder : NSObject <RHSocketEncoderProtocol>

@end


RHSocketHttpEncoder.m文件：

[objc] view plain copy
#import "RHSocketHttpEncoder.h"
#import "RHSocketConfig.h"

@implementation RHSocketHttpEncoder

- (void)encodePacket:(id<RHSocketPacketContent>)packet encoderOutput:(id<RHSocketEncoderOutputDelegate>)output
{
NSData *data = [packet data];
NSMutableData *sendData = [NSMutableData dataWithData:data];
NSData *crlfData = [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding];//回车换行是http协议中每个字段的分隔符，也是请求的结束符
[sendData appendData:crlfData];

NSTimeInterval timeout = [packet timeout];
NSInteger tag = [packet tag];
RHSocketLog(@"tag:%ld, timeout: %f, data: %@", (long)tag, timeout, sendData);
[output didEncode:sendData timeout:timeout tag:tag];
}

@end


RHSocketHttpDecoder.h文件：（http协议的测试解码器）

[objc] view plain copy
#import <Foundation/Foundation.h>
#import "RHSocketDecoderProtocol.h"

@interface RHSocketHttpDecoder : NSObject <RHSocketDecoderProtocol>

@end


RHSocketHttpDecoder.m文件：

[objc] view plain copy
#import "RHSocketHttpDecoder.h"
#import "RHSocketConfig.h"
#import "RHPacketHttpResponse.h"

@interface RHSocketHttpDecoder ()
{
NSMutableData *_receiveData;
}

@end

@implementation RHSocketHttpDecoder

- (NSUInteger)decodeData:(NSData *)data decoderOutput:(id<RHSocketDecoderOutputDelegate>)output tag:(long)tag
{
@synchronized(self) {
if (_receiveData) {
[_receiveData appendData:data];
} else {
_receiveData = [NSMutableData dataWithData:data];
}

NSUInteger dataLen = _receiveData.length;
NSInteger headIndex = 0;
int crlfCount = 0;

for (NSInteger i=0; i<dataLen; i++) {
uint8_t byte;
[_receiveData getBytes:&byte range:NSMakeRange(i, 1)];
if (byte == 0x0a) {//0x0a是http协议中的字段分隔符，我们只是测试程序，简单解析对应返回数据，然后打印
crlfCount++;
}
if (crlfCount == 2) {
NSInteger packetLen = i - headIndex;
NSData *packetData = [_receiveData subdataWithRange:NSMakeRange(headIndex, packetLen)];
RHPacketHttpResponse *rsp = [[RHPacketHttpResponse alloc] initWithData:packetData];
[output didDecode:rsp tag:0];
headIndex = i + 1;
crlfCount = 0;
}
}

NSData *remainData = [_receiveData subdataWithRange:NSMakeRange(headIndex, dataLen-headIndex)];
[_receiveData setData:remainData];

return _receiveData.length;
}//@synchronized
}

@end

测试调用方法：

[objc] view plain copy
NSString *host = @"www.baidu.com";
int port = 80;

[RHSocketService sharedInstance].encoder = [[RHSocketHttpEncoder alloc] init];
[RHSocketService sharedInstance].decoder = [[RHSocketHttpDecoder alloc] init];
[[RHSocketService sharedInstance] startServiceWithHost:host port:port];
也可以继承RHSocketService对象，重载里面的接口方法，增加短线重连等等逻辑。


总结：

以上就是针对http协议实现的测试代码，我们可以看到，socket框架中的代码无需修改，完全可以共用。

这样以后即使是不同应用，不同的业务协议，也不需要重复造轮子了。

文章中都是以代码的方式呈现的，习惯看代码的同学可能比较易懂，但是缺乏整体框架的说明描述。

下一篇，针对当前的框架，绘制uml类图结构。

