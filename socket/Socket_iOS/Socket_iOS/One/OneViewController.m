//
//  OneViewController.m
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import "OneViewController.h"
#import "RHSocketConnection.h"
#import "AManager.h"
#import<AFNetworking.h>
@interface OneViewController ()<RHSocketConnectionDelegate>
{
    NSString *_serverHost;
    int _serverPort;
    RHSocketConnection *_connection;
}
@property(nonatomic,strong) AFHTTPSessionManager * sessionManager;
@property (weak, nonatomic) IBOutlet UILabel *label;


@property(nonatomic,strong)AManager * mmm;
@end

@implementation OneViewController
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.securityPolicy.allowInvalidCertificates = NO;
        [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"image/jpeg",nil]];
        ((AFJSONResponseSerializer *)_sessionManager.responseSerializer).removesKeysWithNullValues = YES;
    }
    return _sessionManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    AManager * mmm = [AManager manager];
    [mmm GetBlock:^(NSString *str) {
        NSLog(@"MMMMMM %@",str);
    }];
    self.mmm = mmm;
    
    
    
    _serverHost = @"www.baidu.com";
    _serverPort = 80;
    [self openConnection];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.mmm click];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.sessionManager GET:@"http://116.62.160.241:8091/api/v1/token"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@请求失败 failed~~~~~~~~~~,%@",task.originalRequest.URL,[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
         
        
         
         self.label.text = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
     }];
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
-(void)dealloc
{
    
}
@end  
