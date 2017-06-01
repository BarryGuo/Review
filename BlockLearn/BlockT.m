//
//  BlockT.m
//  BlockLearn
//
//  Created by Barry on 2017/6/1.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "BlockT.h"

@implementation BlockT

- (void)putBlockA:(void (^)(void))blockA{
    blockA();
}

- (void)putBlockB:(void (^)(NSString *))blockB{
    blockB(@"BlockB");
}

- (void)putBlockC:(NSString *(^)(void))blockC{
    NSString * stirng = blockC();
    NSLog(@"%@", stirng);
}

- (void)putBlockD:(NSString *(^)(NSString *))blockD{
   NSString * string = blockD(@"blockd");
    NSLog(@"%@", string);
}



- (void (^)(void))blockH{
    return ^{
        NSLog(@"blockH");
    };
}

- (void (^)(NSString *))blockI{
    return ^(NSString *string){
        NSLog(@"blockI %@", string);
    };
}

- (NSString *(^)(void))blockJ{
    return ^{
        return @"blockJ";
    };
}

- (NSString *(^)(NSString *))blockK{
    return ^(NSString * string){
        return string;
    };
}


@end
