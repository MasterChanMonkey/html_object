//
//  RHSocketPacket.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/1.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RHSocketPacket <NSObject>

@property (nonatomic, assign, readonly) NSInteger tag;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data;

@optional

- (void)setTag:(NSInteger)tag;
- (void)setData:(NSData *)data;

@end
