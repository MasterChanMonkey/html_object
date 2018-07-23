//
//  RHPacketHttpRequest.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHPacketBody.h"
@interface RHPacketHttpRequest : RHPacketBody
@property (nonatomic, copy) NSString *requestPath;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *connection;
@end
