//
//  Advanced.m
//  BlockLearn
//
//  Created by Barry on 2017/6/6.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "Advanced.h"

#import "BlockT.h"
#import "Block循环引用.h"


@implementation Advanced


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
     当block的结构体实例需要保存自动变量时，该block的结构体实例设置在程序的栈区域。如下所示：
     typedef int (^Blk)(int);
     for(int rate =0 ; rate < 10; ++rate){
     Blk blk = ^(int count){ return rate * count};
     }
     
     总结如下： 记述全局变量的地方有block语法时
     block语法的表达式中不适用应截获的自动变量时。
     在以上的情况下，block为_NSContreteGlobalBlock对象。即对象配置在程序的数据区域中。
     除此外的Block语法生成的为_NSContreteStackBlock对象。且设置在栈上。
     
     
     
     _NSContreteMallocBlock    impl.isa = &_NSContreteMallocBlock
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
    Block____ *blk____ = [[Block____ alloc] init];
    blk____.blk();
    blk____.blk = nil;
    /*
     如果block对引用的自动变量进行强引用，并且自动变量也对block进行强引用，并且在之后没有做其它的操作去打破这种关系，那么就会造成循环引用，在该释放的时候不释放，出现内存泄漏
     
     基本上，我们有三种方法去避免:
     
     1、对block要引用的自动变量使用 __weak 或者 __unsafe__unretained修饰符。block对自动变量进行弱引用。这是最好的方式
     
     2、对block要引用的自动变量使用 __block修饰符，在block中对自动变量进行置nil处理。这种方式其实循环引用已经被建立，只不过在block执行中强行打破。block必须被执行才能打破这种循环
     
     
     3、在外部调用，强行将block置空
     例如 blk____.blk = nil;
     
     
     */
    
    
    
#pragma mark copy/realse
    /*
     ARC无效的情况下，一般需要手动将block从栈复制到堆。另外，由于ARC失效，所以需要释放复制的block。我们使用copy来复制，使用release来释放
     
     void (^blk_on_heap)(void) = [blk_on_stack copy];
     [blk_on_heap  release]
     
     只要block有一次复制并配置在堆上，我们就能通过retain持有
     [blk_on_heap retain]
     
     但是对于配置在栈上的block调用copy是无效的
     [blk_on_stack retain]  //没有任何作用
     
     */
    
    /*
     ARC无效的情况下，__block修饰符可以用来避免block的循环引用。
     这是因为，当block从栈被复制到堆时，若block使用的变量为附有__block修饰的id类型或者对象类型的变量，不会被retain；若没用使用__block，这会被retain，造成循环引用。
     
     但是，如果arc有效的情况下，仅仅用__block是不能避免循环引用的。
     
     
     */
    
    NSLog(@"block end");
    
}



- (void)GCDT{
    
    /*
     异步调用的技术之一
     
     多线程
     一个cpu执行的cpu命令行列为一条无分叉的路径，即为线程。
     
     使用多线程的程序可以在某个线程和其它线程之间反复多次的进行上下文切换，看起来就像1个cpu核可以能够并列的执行多个线程一样。
     
     如果在具有多个核的情况下就不是看上去像，而是真的能够多个核并行执行多个线程了。
     
     这种利用多线程编程的技术就是 "多线程编程技术"
     
     
     多线程容易导致的问题:
     数据竞争:多个线程更新同样的资源导致数据不一致
     死锁:多个线程互相等待
     使用太多线程会消耗大量内存等
     
     
     
     
     dispatch_async(queue, ^{
     //长时间处理
     dispatch_async(dispatch_get_main_queue(), ^{
     //主线程执行
     });
     });
     
     */
    
    
#pragma mark  Dispatch Queue
    /*
     开发者要做的只是定义想执行的任务加到合适的Dispatch Queue中
     
     加入的队列中，采用FIFO的原则
     
     队列分两种: 串行(Serial Dispatch Queue) 和 并行(Concurrent Dispatch Queue)
     
     串行: 一个任务接着一个任务在当前线程顺序执行
     
     并行:系统根据当前分配新的线程，同时执行多个任务，但是并不一定对每个任务都开新线程，根据情况会复用线程
     
     */
    
#pragma mark  dispatch_queue_create
    
    /*
     通过GCD的API生成Dispatch_Queue
     
     串行队列可以申请很多个，但是不建议这么做，太耗内存。一般操作一个资源就只用一个线程
     */
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.example.barry.SerialDispatchQueue", NULL);
    
    /*
     并行队列
     */
    dispatch_queue_t  myConcurrentDispatchQueue = dispatch_queue_create("com.example.barry.ConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myConcurrentDispatchQueue, ^{
        NSLog(@"block on concurrenDispatchQueue");
    });
    
    
    /*
     在ios6以下，create出来的GCD需要进行release
     */
    
    
#pragma mark Main Dispatch Queue/ Global Dispatch Queue
    
    
    
    
#pragma mark dispatch_set_target_queue
    
    /*
     变更线程的优先级
     */
    dispatch_queue_t globalDispatchQueueBackGround = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_queue_t mySerialDispatchQueue2 = dispatch_queue_create("com.example.gcd.MySerialDispatchQueue", NULL);
    dispatch_set_target_queue(mySerialDispatchQueue2, globalDispatchQueueBackGround);
    
#pragma mark dispatch_after
    
    /*
     任务延迟加入到指定线程队列中
     */
    
#pragma mark dispatch group
    /*
     将多个任务并行执行，全部完成后，通知执行结束任务。
     比如异步下载多张图片，全部下载成功后再通知合成成一张图片
     */
    dispatch_queue_t globalDispatchQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t queueGroup = dispatch_group_create();
    
    dispatch_group_async( queueGroup, globalDispatchQueue2, ^{
        NSLog(@"任务1 thread：%@",[NSThread currentThread]);
    });
    dispatch_group_async( queueGroup, globalDispatchQueue2, ^{
        NSLog(@"任务2 thread:%@",[NSThread currentThread]);
    });
    dispatch_group_async( queueGroup, globalDispatchQueue2, ^{
        NSLog(@"任务3 thread:%@", [NSThread currentThread]);
    });
    dispatch_group_notify(queueGroup, dispatch_get_main_queue(), ^{
        NSLog(@"执行结束任务 thread:%@", [NSThread currentThread]);
    });
    
    /*
     可以使用dispatch_group_wait来判断是否全部执行完成
     */
    long result = dispatch_group_wait(queueGroup, dispatch_time(DISPATCH_TIME_NOW, 2));
    if (result == 0) {
        //队列组全部执行完成
    }else{
        //没有完成
    }
    
#pragma mark dispatch_barrier_async
    /*
     在数据库操作中，读取操作可以并行执行，但是写入操作不能并行操作，否则容易出现数据竞争。
     
     写入操作的过程中，不应该同时进行读取操作，否则容易出现数据不一致。
     */
    
    dispatch_queue_t queueBarrier = dispatch_queue_create("com.dispatch.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 1, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 2, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 3, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 4, thread:%@", [NSThread currentThread]);
    });
    //写入操作，只有写入操作完成之后，后面的操作才能继续
    dispatch_barrier_async(queueBarrier, ^{
        NSLog(@"writing thread %@ ", [NSThread currentThread]);
    });
    
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 5, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 6, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 7, thread:%@", [NSThread currentThread]);
    });
    dispatch_async(queueBarrier, ^{
        NSLog(@"reading 8, thread:%@", [NSThread currentThread]);
    });
    
    
    
#pragma mark dispatch_sync 死锁
    /*
     async  非同步    block任务非同步的追加到指定的queue中。async不做任何等待。
     sync  同步   block任务同步的追加到指定的queue中。在block任务结束之前，dispatch_sync函数会一直等待。
     */
    
    /*
     一旦调用dispatch_sync函数，那么在指定的处理执行结束之前，该函数不会返回。dispatch_sync函数可简化源代码，相当于简易版的dispatch_group_wait函数
     */
    dispatch_queue_t queueGlobal2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queueGlobal2, ^{
        NSLog(@"同步任务 thread:%@", [NSThread currentThread]);
    });
    NSLog(@"同步任务完成");
    
    /*
     主线程在等待dispatch_sync的结果返回,而加到当前主线程的block又需要主线程来执行。
     两者互相等待，造成死锁。
     
     dispatch_queue_t queueMian3 = dispatch_get_main_queue();
     dispatch_sync(queueMian3, ^{
     NSLog(@"hello?");
     });
     */
    
    /*
     同步队列也会产生相同的问题，其实主线程就是一种特殊的同步队列
     
     dispatch_queue_t queueSerialDispatchQueue2 = dispatch_queue_create("com.example.gcd.serialDispatchQueue", NULL);
     dispatch_async(queueSerialDispatchQueue2, ^{
     dispatch_sync(queueSerialDispatchQueue2, ^{
     NSLog(@"同步任务");
     });
     });
     */
    
    
#pragma mark dispatch_apply
    /*
     dispatch_apply可以将指定的多个block追加到指定的Dispatch Queue中，并等待全部处理执行结束
     */
    dispatch_queue_t queueGlobal3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queueGlobal3, ^(size_t index) {
        NSLog(@"dispatch_apply %zu", index);
    });
    NSLog(@"done");
    
    /*
     由于dispatch_apply函数也和dispatch_sync函数相同，会等待处理执行结果.因此，推荐在dispatch_async函数中非同步的执行dispatch_apply函数
     */
    NSArray * array1 = [NSArray arrayWithObjects:@1,@2,@3 ,nil];
    
    dispatch_queue_t queueGlobal4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //在 global dispatch queue 中非同步执行
    dispatch_async(queueGlobal4, ^{
        
        //global dispatch queue,等待dispatch_apply函数全部处理执行结束
        dispatch_apply([array1 count], queueGlobal4, ^(size_t index) {
            
            //并行处理包含在NSArray对象中的全部对象
            NSLog(@"%zu:%@ thread = %@", index, [array1 objectAtIndex:index], [NSThread currentThread]);
        });
        
        //dispatch_array函数全部执行结束
        //转到Main Dispatch Queue中非同步执行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //在Main dispatch Queue中更新
            NSLog(@"done");
        });
    });
    
    
#pragma mark dispatch_suspend / dispatch_resume
    /*
     
     dispatch_suspend(queue) 挂起指定的queue
     dispatch_resume(queue) 恢复指定的queue
     
     这些函数对已经执行的处理没有影响。挂起后，追加到queue中尚未执行的block在此之后不会执行。而恢复则使得这些处理能够继续执行。
     
     */
    
#pragma mark dispatch semaphore
    
    /*
     在进行并行处理更新数据时，会产生数据不一致的情况，有时可能导致异常结束。
     当前避免’数据竞争‘的方法有   Serial Dispatch Queue 和 dispatch_barrier_async。
     但有时还需要更细粒度的排他控制。
     */
    
    /*
     因为该源代码使用Global Dispatch Queue更新NSMutableArray类对象，所以执行后由内存错误导致应用程序异常结束的概率很高。此时应使用
     Dispatch Semaphore
     */
    //    dispatch_queue_t queueGlobal5 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    //    for (int i=0; i< 10000; i++) {
    //        dispatch_async(queueGlobal5, ^{
    //            [array2 addObject:[NSNumber numberWithInt:i]];
    //            NSLog(@"%d", i);
    //        });
    //    }
    
    
    dispatch_queue_t queueGlobal6 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /*
     生成 dispatch semaphore。
     dispatch semaphore的计数初始值设定为 1。保证可访问NSmutableArray类对象的线程同时只能有1个
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *array3 = [[NSMutableArray alloc] init];
    for (int i=0; i< 1; i++) {
        dispatch_async(queueGlobal6, ^{
            
            /*
             等待dispatch  semaphore。
             一直等待，直到 dispatch semaphore的计数值 大于等于1
             */
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            /*
             由于dispatch semaphore的计数值达到大于等于1
             所以将 dispatch semaphore的计数值减去1
             dispatch_semaphore_wait 函数执行返回
             
             即执行到此时的 dispatch semaphore的计数值恒为 0
             
             由于可访问NSMutableArray类对象的线程只有一个，因此可安全地进行更新
             */
            
            [array3 addObject:[NSNumber numberWithInt:i]];
            NSLog(@"%d", i);
            
            /*
             排他控制结束
             所以通过 dispatch_semaphore_signal函数 将 dispatch semaphore的计数值加1
             */
            dispatch_semaphore_signal(semaphore);
            
        });
    }
    
    
    
#pragma mark dispatch once
    /*
     dispatch once 保证应用程序在执行过程中只执行一次指定处理的api。
     */
    static dispatch_once_t Pred;
    dispatch_once(&Pred, ^{
        /*
         这里的代码只执行一次
         */
    });
    
    
#pragma mark  dispatch I/O
    
    /*
     使用dispatch I/O 加快较大文件的读取
     */
    
    
    
    
#pragma mark  GCD实现
    /*
     GCD在系统级即iOS和OS X的核心XNU内核级上实现。无论编程人员如何努力编写管理线程的代码，在性能方面也不可能胜过GCD
     
     GCD的API全部为包含在libdispatch库中的c语言函数上。Dispatch Queue通过结构体和链表，被实现为FIFO队列。FIFO队列管理是通过
     dispatch_async等函数所追加的Block
     
     
     Block先加入到上下文中，在加入到FIFO队列。
     
     当执行block时，先从FIFO取得这个block，然后获取对应的上下文，执行
     
     */
    
    
#pragma mark Dispatch Source
    /*
     dispatch Source 和 dispatch Queue不同，是可以取消的。而且取消时必须执行的处理可指定为回调的block形式。
     */
    
    //使用Dispatch_Source_Type_Timer的定时器的例子
    
    /*
     指定Dispatch_source_type_timer，做成dispatch source
     
     在定时器经过指定时间时设定 Main dispatch Queue 为追加处理的 dispatch queue
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    /*
     将定时器设定在15秒后，不指定重复， 允许延迟1秒
     */
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC),
                              DISPATCH_TIME_FOREVER,
                              1 * NSEC_PER_SEC);
    
    
    /*
     指定定时器时间内执行的任务
     */
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"wakeup!");
        
        /*
         取消 dispatch source
         */
        dispatch_source_cancel(timer);
    });
    
    /*
     指定取消 dispatch source 时的操作
     */
    dispatch_source_set_cancel_handler( timer, ^{
        NSLog(@"canceld");
        
        
    });
    
    
    dispatch_resume(timer);
}



@end
