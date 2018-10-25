//
//  Person.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/25.
//  Copyright © 2018 whs. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

- (void)getInformation{
    NSLog(@"我的名字是：%@==我的住址是：%@", self.name, self.address);
}

- (void)play{
    //[self play];
    NSLog(@"paly == 去跑步");
}
- (void)eat{
    NSLog(@"eat == 去吃饭");
}
+ (void)study{
    NSLog(@"study == 去学习");
}
+ (void)sleep{
    NSLog(@"sleep == 去睡觉");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(buy)){
        //动态添加eat方法
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, sel, (IMP)buyMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void buyMethod(id self, SEL sel){
    NSLog(@"动态添加方法 === buy");
}



@end
