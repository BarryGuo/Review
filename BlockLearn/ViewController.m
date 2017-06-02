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
    
    
    /*
     block在实现中不能改写被截获的自动变量的值，所以当编译器在编译过程中检出给被截获的自动变量赋值的操作时，就会产生编译错误。
     这样一来就无法在block中报错值。解决这个问题有两方法。
     
    方法一:使用 静态变量  静态全局变量   全局变量
     
    int global_val = 1;
    static int static_global_val = 2;
    int main()
    {
        static int static_val =3;
        void (^static_method_blk)(void)=^{
            global_val = 2;
            static_global_val = 3;
            static_val = 4;
        };
        static_method_blk();
    }
     
     
     方法二：使用__block修饰符
    
   */
    
    
#pragma mark block本质
    
    /*
     使用命令 -rewrite-objc 文件名能将含有block语法的源码转成c++源代码.。说是c++,其实仅仅是使用了struct结构,其本质是C语言代码
     
     带有自动变量值的匿名函数
     
     block使用的匿名函数实际被当成简单的c语言函数来处理
     
     block是object-c的对象
     block的实例结构体的isa指向 NSConcreteStackBlock。
     */
    
    /*
     “Objective-C中由类生成对象”意味着，像类结构体这样"生成由该类生成的对象的结构体实例"。生成的各个对象，即由该类生成的对象的各个结构体实例，通过成员变量isa保持该类结构体的实例指针。
     
     */
    
    /*
     "截获自动变量值"意味着在执行block语法中，block语法表达式所使用的自动变量会被保持到block的结构体中(即block自身)
     */
    

#pragma mark block存储域
    /*
     
     
    | ----------------------------------------------------------------------------
    |    类型                  |    设置对象的存储域
    | ----------------------------------------------------------------------------
    | _NSConcreteStackBlock   |   该类的对象block(结构体)设置在栈上
    | ----------------------------------------------------------------------------
    | _NSConcreteGlobalBlock  |  该类的的对象block设置在数据区域(data区)
    | ----------------------------------------------------------------------------
    | _NSConcreteMallocBlock  |  该类的对象block设置在由malloc函数分配的内存块(即堆)中
    | ----------------------------------------------------------------------------
     
     
     _NSConcreteGlobalBlock
     当block的结构体实例不需要保存自动变量时，该block的结构体实例设置在程序的数据区域。如下所示：
     
     void (^blk)(void) = ^{ printf("GlobalBlock\n")};
     
     
     _NSConcreteStackBlock
     当block的结构体实例需要保存自动变量时，该block的结构体实例设置在程序的数据区域。如下所示：
     typedef int (^Blk)(int);
     for(int rate =0 ; rate < 10; ++rate){
        Blk blk = ^(int count){ return rate * count};
     }
     
     总结如下： 记述全局变量的地方有block语法时
              block语法的表达式中不适用应截获的自动变量时。
     在以上的情况下，block为_NSContreteGlobalBlock对象。即对象配置在程序的数据区域中。
     除此外的Block语法生成的为_NSContreteStackBlock对象。且设置在栈上。
     
     
     
     _NSContreteGlobalBlock    impl.isa = &_NSContreteMallocBlock
     配置在全局变量上的block，从变量的作用域外也可以安全地通过指针使用。但是设置在栈上的block,如果其所属的变量作用域结束，该block也被废弃。
     由于__block变量也设置在栈上，同样会被废弃。
     
     通过将block 和__block变量复制到堆上，即使block语法记述的变量作用域结束，堆上的block还可以继续存在。而__block变量用结构体成员变量__forwarding 可以实现无论__block变量配置在栈上还是堆上都可以正确反问__block对象。
     
    当ARC有效时，大部分情形下编译器会恰当地进行判断，自动生成将block从栈上复制到堆上的代码。比如下面这段代码
     typedef int (^blk_t)(int);
     blk_t func(int rate){
        return ^(int count){ return rate * count };
     }
     
     那么时候情况下，编译器不能进行准确判断呢。如下所示: 
     -- 向方法或者函数的参数中传递block时。
     这也不是绝对的，以下方法 或者函数不需要手动复制
     -- Cocoa框架的方法且方法名中含有usingBlock等时
     -- GCD的API
     
     
     id blockArray = [self getBlockArray];
     void (^blk)(void) = blockArray[0];
     blk();
     
     - (id)getBlockArray{
        int val = 10;
        int val2 = 20;
        return  [[NSArray alloc] initWithObjects:
                        [^{NSLog(@"blk1:%d",val);} copy] ,
                        [^{NSLog(@"blk2:%d", val2);} copy],
                        nil];
     }
     
     如上面的示例，如果不使用copy，在执行 blk()会发生异常，因为此时block已经被废弃。
     
     
     调用copy方法的效果:
     
     block类                        来源             复制效果
     _NSContreteStackBlock          栈               栈->堆
     _NSContreteGlobalBlock         数据区            什么都不做
     _NSContreteMallocBlock         堆                引用计数增加
     
     对一个block多次调用copy,ARC有效时完全没有问题
     
     */
    
    
    
#pragma mark   __block变量存储域
    /*
     
     Block从栈复制到堆时对__block变量产生的影响
     
     __block变量的配置存储域           Block从栈复制到堆时的影响
      栈                             从栈复制到堆并被block持有
      堆                             被block持有

     
     */
    
    
#pragma mark  截获对象
    /*
     只有调用了_Block_copy函数才能持有截获的附有__strong修饰符的对象类型的自动变量值。
     
     
     栈上的block复制到堆上的时机:
     -- 主动调用block的copy方法时
     -- block作为函数返回值返回时
     -- 将block赋值给附有__strong修饰符的id类型的类或者Block类型的成员变量时
     -- 在方法中含有usingBlock的cocoa框架方法或者GCD的API传递Block时
     
     */
    typedef  void (^blk_t) (id);
    blk_t blk;
    {
        id array = [[NSMutableArray alloc] init];
        
        //按照内存管理这本书上的描述，这里不对block块调用copy是会崩的。可能苹果有修改，现在尝试后不崩
        blk = ^(id obj){
            [array addObject:obj];
            NSLog(@"array count = %ld", [array count]);
        } ;
    }
    
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    
    
 
#pragma mark __block变量和对象
    /*
     __block说明符可指定任何类型的自动变量。
      
     __block id obj = [[NSObject alloc] init];
     
     该代码等同于:  __block id __strong obj = [[NSObject alloc] init];  ARC情况下，__strong缺省
     
     */
    void (^blk__block)(id);
    {
        id array = [[NSMutableArray alloc] init];
        __block id __weak array2 = array;
        
        //实际测试发现是否使用copy不会影响结果
        blk__block =[ ^(id obj){
            [array2 addObject:obj];
            NSLog(@"array2 count = %ld", [array2 count]);
        } copy];
    }
    
    /* 输出结果为 0 0 0 */
    blk__block([[NSObject alloc] init]);
    blk__block([[NSObject alloc] init]);
    blk__block([[NSObject alloc] init]);
    
    
    
    
    /*
     
     为什么在block中不能修改变量值?
     
     假设block截取了自动变量val。
     struct void __main_block_func_0(struct __main_block_impl_0 *__cself){
        int val = __cself->val;   //完全就是一个拷贝，很重要
        printf("val = %d",val);
     }
     参见上面这段代码，block中用到的变量val除了值外截取的自动变量val一样，没有其他一样的地方了。说白了，这是一份拷贝，和从外部截取的自动变量时两码事。
     
     当然这并没有什么影响，甚至还有好处，因为int val变量定义在栈上，在block调用时其实已经被销毁，但是我们还可以正常访问这个变量。但是试想一下，如果我希望在block中修改变量的值，那么受到影响的是int val而非__cself->val，事实上即使是__cself->val，也只是截获的自动变量的副本，要想修改在block定义之外的自动变量，是不可能的事情
     既然无法实现修改截获的自动变量，那么编译器干脆禁止程序员这么做了。
     
     
     
     为什么使用__block就可以修改呢？
     
     改动并不大，简单来说，只是把val封装在了一个结构体中而已。
     关键在于_main_block_impl_0结构体中的这一行:
     __Block_byref_val_0 * val;
     
     由于_mian_block_impl_0这个结构体保存了一个指针变量，所以任何对这个指针的操作，是可以影响变量的。同时，使用__block修饰的变量会被拷贝到堆上，这样在离开作用域后不会被销毁。
     
     
     
     
     
     __block修饰的属性可以再block中赋值的原因:
     
     block不允许修改外部变量的值，这里值的外部变量，指的是栈中指针的内存地址。__block起到的作用就是只要观察到该变量被block持有，就将"外部变量"在栈中的内存地址放到堆中。进而在block内部也可以修改外部变量的值
     
     block属于"函数的"范畴，变量进入block，实际上已经改变了作用域。在几个作用域中进行切换时，如果不加上这样的限制，变量的可维护性将大大降低。只有加上这样的限制，才更合理。
     
     __block变量在进入block区域后会被拷贝到堆上。前后的地址并不一样。定义时在栈区，进入block区域后变成堆区。
     
     */
    __block int a__block = 1 ;
    NSLog(@"%p", &a__block);
    void (^blk__block_copy)(void) = ^{
        NSLog(@"a = %d", a__block);
    };
    a__block= 3;
    NSLog(@"%p", &a__block);
    blk__block_copy();
    NSLog(@"%p", &a__block);
    
    
   

#pragma mark Block循环引用
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
