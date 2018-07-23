//
//  Bdelegate.h
//  Socket_iOS
//
//  Created by 北辰青 on 2018/3/2.
//  Copyright © 2018年 北辰青. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BdelegateBlock)(NSString * str);
@protocol BdelegateContent <NSObject>
-(void)getString:(NSString *)Str;
@end

@interface Bdelegate : NSObject
@property(nonatomic,weak) id<BdelegateContent> delegate;
@property(nonatomic,copy) BdelegateBlock block;

-(void)setString:(NSString *)str;
@end
