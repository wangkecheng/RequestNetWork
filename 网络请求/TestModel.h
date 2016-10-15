//
//  TestModel.h
//  网络请求
//
//  Created by warron on 2016/10/15.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Pagination : NSObject
@property (nonatomic,strong)NSNumber *limit;

@property (nonatomic,strong)NSNumber *offset;

@end

@interface OneUser : NSObject

@property (nonatomic,strong)NSString *owner;
@end
@interface TestModel : NSObject
@property (nonatomic,strong)NSString *resultMode;

@property (nonatomic,strong)NSString *modelType;

@property (nonatomic,strong)NSString *sessionID;

@property (nonatomic,strong)NSString *orderBy;

@property (nonatomic,strong)Pagination *pagination;

@property (nonatomic,strong)OneUser *oneUser;
@end
