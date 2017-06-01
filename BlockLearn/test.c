//
//  test.c
//  BlockLearn
//
//  Created by guoqingping on 2017/6/1.
//  Copyright © 2017年 barry. All rights reserved.
//





#include <stdio.h>
int main(void) {
    // insert code here...
    void (^blk)(void) = ^{
        printf("block\n");
    };
    blk();
    return 0;
}
