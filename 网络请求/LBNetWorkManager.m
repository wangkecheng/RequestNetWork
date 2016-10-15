//
//  LBNetWorkManager.m
//  lubanlianmeng
//
//  Created by warron on 2016/10/14.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "LBNetWorkManager.h"
#import<objc/runtime.h>

typedef  void  (^Success)(id result);
typedef  void (^Fault) (id result);
@interface LBNetWorkManager()


@property (nonatomic,strong)NSMutableData * receiveData;

@property (nonatomic,copy)Success  success;

@property (nonatomic,copy)Fault fault;

@end

@implementation LBNetWorkManager

+(LBNetWorkManager *)netManager{
    LBNetWorkManager *netManager = [[LBNetWorkManager alloc]init];
    return netManager;
}

#pragma mark urlStr直接传入拼接的字符串 obj必须是传入一个对象
-(void)Post:(NSString *)urlStr obj:(id)obj Success:(void (^)(id result))success Fault:(void (^)(id result))fault{
    
    
    //成功的回调
    _success  = success;
    
    //失败的回调
    _fault  = fault;
    
    //构建为请求url
    NSURL * url = [NSURL URLWithString:urlStr];
    
    //获取json格式的data
    NSData *data = [self getJSON:obj];
    
    //设置请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //请求方式
    [request setHTTPMethod:@"POST"];
    
    //请求内容格式
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //请求体
    [request setHTTPBody:data];
    
    //开始连接
    NSURLConnection * connection  = [[NSURLConnection alloc]initWithRequest:request delegate:self];

}

//当连接通了之后再做初始化
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
     //请求的返回信息
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //信息是一个一个的来的 所以就需要将返回的信息追加到数据后面
    [self.receiveData appendData:data];
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
     //将得到的信息转为字典
    NSDictionary * dictAnalysis= [self receiveDataChangeTouchDictionary];
    //在这里返回数据
    _success(dictAnalysis);
}
//请求成功后，将返回的数据转换为字典
- (NSDictionary *)receiveDataChangeTouchDictionary{
    //判断是否为空，为空则不转
    if (!_receiveData) {
        return nil;
    }
    NSError *error;
    //转为字典
    NSDictionary *dictAnalysis = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingMutableContainers  error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dictAnalysis;
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error{
    
    //返回错误信息
    _fault(error);
}

//获取json格式的数据
-(NSData*)getJSON:(id)obj{
    
    return [self getJSON:obj options:NSJSONWritingPrettyPrinted error:nil];
}
-(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error{
    
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}
//将对象的属性和值对应起来， 作为字典的格式
-(NSDictionary*)getObjectData:(id)obj{
    
    NSMutableDictionary
    *dic = [NSMutableDictionary dictionary];
    
    unsigned
    int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++){
        
        objc_property_t prop = props[i];
        
        NSString  *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [obj valueForKey:propName];
        
        if(value == nil) {
           value = [NSNull null];
        }
        
        else {
          value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    return dic;
    }

-(id)getObjectInternal:(id)obj{
    
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]){
        
        return obj;
    }
    
    if([obj  isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        
        NSMutableArray  *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int  i = 0;i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if([obj  isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary  *objdic = obj;
        
        NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys){
          [dic  setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return  dic;
    }
    
    return [self getObjectData:obj];
}
@end
