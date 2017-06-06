//
//  ViewController.m
//  BlockLearn
//
//  Created by Barry on 2017/6/1.
//  Copyright © 2017年 barry. All rights reserved.
//

#import "ViewController.h"

#import "Advanced.h"
#import "tip52/Tips52.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    Advanced * adv =  [[Advanced alloc] init];
    [adv GCDT];
    
    
   Tips52 *tip52 =  [[Tips52 alloc] init];
    [tip52 excute];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
