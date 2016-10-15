//
//  TestModel.m
//  网络请求
//
//  Created by warron on 2016/10/15.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "TestModel.h"

@implementation Pagination
-(instancetype)init{
    if (self = [super init]) {
        _limit = @10;
        _offset =@0;
    }
    return  self;
}

@end
@implementation OneUser

-(instancetype)init{
    if (self = [super init]) {
        _owner = @"7dca0e67-6bba-458b-b7af-094582d2ca06";
    }
    return  self;
}
@end


@implementation TestModel
-(instancetype)init
{
    if (self = [super init]) {
        _resultMode = @"full";
        _modelType = @"shouCang";
        _sessionID = @"409d3c47-54d1-41f0-bc51-590979a7156c_session";
        _orderBy  = @"geo";
        _pagination = [[Pagination alloc]init];
        _oneUser = [[OneUser alloc]init];
    }
    return  self;
}

@end
