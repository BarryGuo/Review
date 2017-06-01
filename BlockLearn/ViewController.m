//
//  ViewController.m
//  BlockLearn
//
//  Created by Barry on 2017/6/1.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "ViewController.h"

#import "BlockT.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self blockt];
    
    
}


- (void)blockt{
    BlockT * blockt = [[BlockT alloc] init];
    
    
    /*
     block的写法基本就分3种：
     1、作为属性或者变量声明时。返回类型和参数类型都不能少。写法：  返回类型 (^block名称)(参数类型)
     
     2、作为方法参数或者返回值时。返回类型和参数类型都不能少。写法:    ( 返回类型 (^)(参数类型)) block名称
     
     3、赋值时。返回类型可以省略，参数类型如果为空也可以省略。  写法:  ^ 返回类型(参数类型){ }
     
     
     
     */
    
    blockt.block1 = ^{
        NSLog(@"没有参数 没有返回值");
    };
    blockt.block1();
    
    
#pragma mark block作为属性
    
    blockt.block2 = ^(NSString *string) {
        NSLog(@"%@", string);
    };
    blockt.block2(@"有参数，没有返回值");
    
    
    
    blockt.block3 = ^NSString *{
        return @"没有参数，有返回值";
    };
    NSString * block3String = blockt.block3();
    NSLog(@"%@", block3String);
    
    
    
    blockt.block4 = ^NSString *(NSString *string) {
        return string;
    };
    NSLog(@"%@", blockt.block4(@"有参数，有返回值"));
    
    
    
#pragma mark block作为方法参数
    
    
    [blockt putBlockA:^{
        NSLog(@"没有参数，没有返回值的block作为参数");
    }];
    
    
    [blockt putBlockB:^(NSString *string) {
        NSLog(@"%@",string);
    }];
    
    
    [blockt putBlockC:^NSString * {
        
        return  @"没有参数，有返回值的block作为参数";
    }];
    
    
    [blockt putBlockD:^NSString *(NSString *string) {
       
        NSLog(@"%@", string);
        return @"有参数，也有返回值的block作为参数";
    }];
    

#pragma mark block作为返回值
    
    void (^blockH)(void) = [blockt blockH];
    blockH();
    
    
    typedef void (^BlockI)(NSString *);
    BlockI blockI = [blockt blockI];
    blockI(@"有参数，没有返回值的block作为返回值");
    
    
    
    NSString* (^blockJ)(void) = [blockt blockJ];
    NSLog(@"%@", blockJ());
    
    
    NSString * (^blockK)(NSString *) = [blockt blockK];
    NSLog(@"%@", blockK(@"有参数，有返回值的block作为返回值"));
    
    

#pragma mark  __block
    /*
     使用附有__block说明符的自动变量可在block中赋值，该变量称为__block变量
     */
    
    __block int val = 0;
    void (^block__block)(void) = ^{
        val = 1;
    };
    block__block();
    NSLog(@"val = %d", val);
    
    
    
    
    
    /*
     截获oc对象，调用更改该对象的方法不会产生编译错误，但是赋值则会产生编译错误
     */
    id array = [[NSMutableArray alloc] init];
    void (^array__block)(void) = ^{
        id obj = [[NSObject alloc] init];
        //不会出错
        [array addObject:obj];
        
        //出错
//        array = [NSMutableArray array];
    };
    array__block();
    
    
    
    
    
    /*
     使用c语言数组必须小心指针
     */
    const char cText[] = "hello";
    const char *cTextChar = cText;
    void (^cArray_block)(void) = ^{
        
        //block截获自动变量的方法不会对c语言数组进行截获
//        printf("%c\n", cText[2]);
        
        //可以使用指针解决这个问题
        printf("%c\n", cTextChar[2]);
    };
    cArray_block();

    
    
#pragma mark block本质
    
    /*
     带有自动变量值的匿名函数
     
     
     
     block是object-c的对象
     */
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
