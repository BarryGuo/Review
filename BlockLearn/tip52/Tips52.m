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
    /*
     向前声明(forward declaring)  
     
     1、降低类之间的耦合，避免编译的循环引用
     
     */
    
}

#pragma mark  多用字面量语法，少用与之等价的方法
- (void)tip3{
    //使用字面量语法创建数组或字典时，若值中有nil，则会抛出异常。因此，务必确定值里不含nil。
    
}

#pragma mark 多用类型常量，少用#define预处理指令
-(void)tip4{
    //常用 #define方式，缺点是定义出来的常量没有类型信息，重复定义值还会被覆盖
#define ANIMATION_DURATION 0.3
    
    // static const声明方式。如果声明在.m文件中，static可以保证作用域仅限于该.m文件中，const可以保证变量不被修改
    static const NSTimeInterval KAnimationDuration = 0.3;

   //当需要像外部暴露一个可见的常量变量时，我们使用extern.
    // in the header file
    extern NSString *const constant;
    
    //in the implementation file
//    NSString * const constant = @"value";
    
    /*
     1、不要使用预处理指令定义常量。这样定义出来的常量不含类型信息，编译器只会在编译前据此进行查找和替换操作。即使有人重新定义了常量值，编译器也不会产生警告信息，浙江导致应用程序中常量值不一致
     
     2、在实现文件中使用static const来定义"只在编译单元内可见的常量"。由于此类常量不在全局符号表中，所以无需为此加前缀
     
     3、在头文件中使用extern来声明全局常量，并在相关实现文件中定义其值。这种常量会出现在全局符号表中。
     
     */
    
}

#pragma mark 用枚举表示状态、选项、状态码
-(void)tip5{
    
    //枚举是一种常量命令方式。某个对象所经历
}



@end
