//
//  Block循环引用.h
//  BlockLearn
//
//  Created by guoqingping on 2017/6/4.
//  Copyright © 2017年 barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Block____ : NSObject

@property (nonatomic, copy) void (^blk)(void);

@end
