//
//  ViewController.m
//  网络请求
//
//  Created by warron on 2016/10/15.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "ViewController.h"
#import "LBNetWorkManager.h"
#import "TestModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestModel * textMOdel  =[[TestModel alloc]init];
    
    LBNetWorkManager *manager = [LBNetWorkManager netManager];
    
    [manager Post:@"http://121.196.227.33:1688/api/postSearch" obj:textMOdel Success:^(id result) {
        
        
    } Fault:^(id result) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
