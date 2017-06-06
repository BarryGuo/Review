//
//  Tips52.m
//  BlockLearn
//
//  Created by Barry on 2017/6/6.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "Tips52.h"

@implementation Tips52

- (void)excute{
    
}

#pragma mark 了解OC的起源
- (void)tip1{
    
    /*
     obj使用 "消息结构" 而非 "函数调用"
     
     //messaging (OC)
     Object *obj = [Object new];
     [obj performWith:parameter1 and:parameter2];
     
     //function calling (C++)
     Objcet *obj = new Object;
     obj->perform(parameter1, parameter2);
     
     
     
     区别: 使用消息结构的语言，其运行时所应执行的代码由运行环境决定;而使用函数调用的语言，则由编译器决定。
     使用消息结构的语言，编译器不关心接受消息的对象是何种类型，接受消息的对象问题也要在运行时处理，其过程叫做"动态绑定 dynamic binding"
     
     OC的重要工作都由"运行期组件(runtime component)"而非编译器来完成
     
     OC对象所占内存总是分配在"堆空间"(heap space)中，而绝不会分配在"栈"(stack)上。不能在栈上分配对象。
     
     
     */
    
    
    /*
     只有一个NSString实例，这个实例对象保存在堆上。然而有两个变量指向此实例，两个变量都是NSString*型.
     栈区分配两块内存，每块内存存放一个指针
     */
    NSString * string1 = @"the string";
    NSString *string2 = string1;
    
    //CGRect这种是c的结构体，直接使用栈
 
}


#pragma mark  在类的头文件中尽量少引入其他的头文件
- (void)tip2{
    
    
}

@end
