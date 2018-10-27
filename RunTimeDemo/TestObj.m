//
//  TestObj.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/27.
//  Copyright © 2018 whs. All rights reserved.
//

#import "TestObj.h"

@interface TestObj()
{
    NSString *_name;  //优先级1
//    NSString *_isName; //优先级2
//    NSString *name; //优先级3
//    NSString *isName; //优先级4
    
    int _age;
    
}
@end

@implementation TestObj



#pragma mark - KVC
#pragma mark - Setter
//- (void)setName:(NSString *)name{//优先级1
//    NSLog(@"setName");
//    _name = name;
//}
//- (void)_setName:(NSString *)name{//优先级2
//    NSLog(@"_setName");
//}
//- (void)setIsName:(NSString *)name{//优先级3
//    NSLog(@"setIsName");
//}

//- (id)valueForKey:(NSString *)key{
//    NSLog(@"_name：%@", _name);
//    NSLog(@"_isName：%@", _isName);
//    NSLog(@"name：%@", name);
//    NSLog(@"isName：%@", isName);
//    return nil;
//}
#pragma mark - Getter
//- (NSString *)getName{ //优先级1
//    NSLog(@"getName");
//    return nil;
//}
//
//- (NSString *)name{//优先级2
//    NSLog(@"name");
//    return nil;
//}
//- (NSString *)isName{//优先级3
//    NSLog(@"isName");
//    return nil;
//}


+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"setValue异常");
}

- (id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"valueForUndefinedKey异常");
    return nil;
}

#pragma mark - KVO
- (id)init{
    self = [super init];
    if (self) {
        _age = 20;
    }
    return self;
}

- (int)age{
    return _age;
}
- (void)setAge:(int)age{
    [self willChangeValueForKey:@"age"];
    _age = age;
    [self didChangeValueForKey:@"age"];
}

+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"age"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}


@end
