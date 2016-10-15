//
//  LBNetWorkManager.h
//  lubanlianmeng
//
//  Created by warron on 2016/10/14.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBNetWorkManager : NSObject

+(LBNetWorkManager *)netManager;

-(void)Post:(NSString *)urlStr obj:(id)obj Success:(void (^)(id result))success Fault:(void (^)(id result))fault;

@end
