//
//  BlockT.h
//  BlockLearn
//
//  Created by Barry on 2017/6/1.
//  Copyright © 2017年 barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockT : NSObject

#pragma mark 作为属性


// 没有参数，没有返回值
@property (nonatomic, copy) void (^block1) (void);

// 有参数，没有返回值
@property (nonatomic, copy) void (^block2) (NSString *);

//没有参数，有返回值

@property (nonatomic, copy) NSString * (^block3) (void);

// 有参数 有返回值
@property (nonatomic, copy) NSString * (^block4) (NSString *);


#pragma mark 作为方法参数

// 没有参数，没有返回值
- (void)putBlockA:(void (^)(void)) blockA;


// 有参数，没有返回值
- (void)putBlockB:(void (^)(NSString *)) blockB;

//没有参数，有返回值
- (void)putBlockC:(NSString * (^)(void))blockC;

// 有参数 有返回值
- (void)putBlockD:(NSString * (^)(NSString *))blockD;





#pragma mark 作为方法返回值



// 没有参数，没有返回值
- (void (^) (void))blockH;


// 有参数，没有返回值
- (void (^)(NSString *))blockI;

//没有参数，有返回值
- (NSString * (^)(void))blockJ;


// 有参数 有返回值
- (NSString * (^)(NSString *))blockK;

@end
