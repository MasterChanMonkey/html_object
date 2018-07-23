#CocoaAsyncSocket网络通信使用之tcp连接（一）


简述：

在互联网世界中，网络访问是必不可少的一部分，而对于程序员来说，网络编程却是一个比较复杂的存在，特别是socket处理方面。

在android平台中，java类库丰富，封装良好，比如：mina，netty等等。

而在ios平台中，也有出名的socket库，CocoaAsyncSocket。


最近碰到一些朋友在socket的应用上一直不是特别熟悉，自己在接触过socket底层库，使用过mina，netty和CocoaAsyncSocket后，

也想整理一份自己的工具库，于是有如下内容。


CocoaAsyncSocket的功能强大，有tcp和udp两部分，这里只学习整理tcp部分。



建立ios工程：

首先建立一个ios工程，RHSocketDemo. （本例使用pod管理类库，如果不熟悉，可以先看前面的文章：CocoaPods安装和使用教程）

然后在工程目录下建立Podfile文件，内容如下：

platform:ios,'7.0'

pod 'CocoaAsyncSocket', '~> 7.4.1'


然后使用pod instatll —no-repo-update命令，生成工程管理文件。

关闭原先的工程，使用新生成的RHSocketDemo.xcworkspace文件开启工程。


以上是通过pod引入CocoaAsyncSocket库，省去了加入framework的步骤，，比较方便。

也可以下载CocoaAsyncSocket源码，然后将源码加入到工程中，但是需要额外手动加入framework。



构造自己的socket连接类：

1-为了简化类库中的内容，隐藏一些不关心的接口方法。

2-对类库做一层封装隔离，以个人习惯的方式呈现使用（可以方便库的更新替换，比如：asi到afn的http 库迁移）

基于以上两个原因，我们使用CocoaAsyncSocket封装自己的sokcet connection类。代码如下：



RHSocketConfig.h文件：


[objc] view plain copy
#ifndef RHSocketDemo_RHSocketConfig_h
#define RHSocketDemo_RHSocketConfig_h

#ifdef DEBUG
#define RHSocketDebug
#endif

#ifdef RHSocketDebug
#define RHSocketLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define RHSocketLog(format, ...)
#endif

#endif

RHSocketConnection.h文件：

[objc] view plain copy
#import <Foundation/Foundation.h>
#import "RHSocketConfig.h"

@protocol RHSocketConnectionDelegate <NSObject>

- (void)didDisconnectWithError:(NSError *)error;
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)didReceiveData:(NSData *)data tag:(long)tag;

@end

@interface RHSocketConnection : NSObject

@property (nonatomic, weak) id<RHSocketConnectionDelegate> delegate;

- (void)connectWithHost:(NSString *)hostName port:(int)port;
- (void)disconnect;

- (BOOL)isConnected;
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag;

@end

RHSocketConnection.m文件：

[objc] view plain copy
#import "RHSocketConnection.h"
#import "GCDAsyncSocket.h"

@interface RHSocketConnection () <GCDAsyncSocketDelegate>
{
GCDAsyncSocket *_asyncSocket;
}

@end

@implementation RHSocketConnection

- (instancetype)init
{
if (self = [super init]) {
_asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
return self;
}

- (void)dealloc
{
_asyncSocket.delegate = nil;
_asyncSocket = nil;
}

- (void)connectWithHost:(NSString *)hostName port:(int)port
{
NSError *error = nil;
[_asyncSocket connectToHost:hostName onPort:port error:&error];
if (error) {
RHSocketLog(@"[RHSocketConnection] connectWithHost error: %@", error.description);
if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
[_delegate didDisconnectWithError:error];
}
}
}

- (void)disconnect
{
[_asyncSocket disconnect];
}

- (BOOL)isConnected
{
return [_asyncSocket isConnected];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
[_asyncSocket readDataWithTimeout:timeout tag:tag];
}

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag
{
[_asyncSocket writeData:data withTimeout:timeout tag:tag];
}

#pragma mark -
#pragma mark GCDAsyncSocketDelegate method

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
RHSocketLog(@"[RHSocketConnection] didDisconnect...%@", err.description);
if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
[_delegate didDisconnectWithError:err];
}
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
RHSocketLog(@"[RHSocketConnection] didConnectToHost: %@, port: %d", host, port);
if (_delegate && [_delegate respondsToSelector:@selector(didConnectToHost:port:)]) {
[_delegate didConnectToHost:host port:port];
}
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
RHSocketLog(@"[RHSocketConnection] didReadData length: %lu, tag: %ld", (unsigned long)data.length, tag);
if (_delegate && [_delegate respondsToSelector:@selector(didReceiveData:tag:)]) {
[_delegate didReceiveData:data tag:tag];
}
[sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
RHSocketLog(@"[RHSocketConnection] didWriteDataWithTag: %ld", tag);
[sock readDataWithTimeout:-1 tag:tag];
}

@end

测试调用的ViewController.m文件：

[objc] view plain copy
#import "ViewController.h"
#import "RHSocketConnection.h"

@interface ViewController () <RHSocketConnectionDelegate>
{
NSString *_serverHost;
int _serverPort;
RHSocketConnection *_connection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
[super viewDidLoad];

// Do any additional setup after loading the view, typically from a nib.

_serverHost = @"www.baidu.com";
_serverPort = 80;
[self openConnection];
}

#pragma mark -
#pragma mark RHSocketConnection method

- (void)openConnection
{
[self closeConnection];
_connection = [[RHSocketConnection alloc] init];
_connection.delegate = self;
[_connection connectWithHost:_serverHost port:_serverPort];
}

- (void)closeConnection
{
if (_connection) {
_connection.delegate = nil;
[_connection disconnect];
_connection = nil;
}
}

#pragma mark -
#pragma mark RHSocketConnectionDelegate method

- (void)didDisconnectWithError:(NSError *)error
{
RHSocketLog(@"didDisconnectWithError...");
}

- (void)didConnectToHost:(NSString *)host port:(UInt16)port
{
RHSocketLog(@"didConnectToHost...");
}

- (void)didReceiveData:(NSData *)data tag:(long)tag
{
RHSocketLog(@"didReceiveData...");
}

@end

上面的代码中，RHSocketConnection负责网络的连接，ViewController负责测试代码。

连接成功后，会输出：[RHSocketConnection] didConnectToHost: 115.239.210.27, port: 80




