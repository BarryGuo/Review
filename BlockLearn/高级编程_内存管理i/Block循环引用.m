//
//  Block循环引用.m
//  BlockLearn
//
//  Created by guoqingping on 2017/6/4.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "Block循环引用.h"

@implementation Block____

-(instancetype)init{
    if (self = [super init]) {
        
        /*
         self持有block的强引用，block持有self的强引用，导致循环引用，两者都无法释放。
        _blk = ^{
            NSLog(@"self = %@", self);
        };
         */
        
        //解决方法一，对block持有的自动变量才有 __weak或者_unsafe_unretained修饰。self持有block的强引用，但是block持有自动变量self的弱引用，不会导致循环引用
//        id __weak weakself = self;
//        _blk = ^{
//            NSLog(@"self=%@", weakself);
//        };
//        
        
        //解决方法二 使用__block修饰自动变量，并且在block中使用完后置空。必须调用block才置空
        __block id temp = self;
        _blk = ^{
            NSLog(@"self = %@", temp);
            temp = nil;
        };
        
        
    }
    
    return  self;
}

- (void)dealloc{
    
    NSLog(@"dealloc");
}


@end
