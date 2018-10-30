//
//  Tools.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/29.
//  Copyright © 2018 whs. All rights reserved.
// 

#import "Tools.h"


static Tools *_tools = nil;
@implementation Tools
// 为了使实例易于外界访问 一般提供一个类方法
+ (instancetype)shareTools{
    //return _instance;
    //最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
//保证永远都只为单例对象分配一次内存空间,重写allocWithZone方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    @synchronized (self) {
//        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
//        if (_tools == nil) {
//            _tools = [super allocWithZone:zone];
//        }
//        return _tools;
//    }
    //使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tools = [super allocWithZone:zone];
    });
    return _tools;
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _tools;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _tools;
}





@end
