//
//  Person+DefaultOJ.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/25.
//  Copyright © 2018 whs. All rights reserved.
//

#import "Person+DefaultOJ.h"
#import <objc/message.h>

@implementation Person (DefaultOJ)
@dynamic phone;
static char kDefaultNameKey;
/**
   关联对象Runtime提供了下面几个接口：
   id object：被关联的对象
   const void *key：关联的key，要求唯一
   id value：关联的对象
   objc_AssociationPolicy policy：内存管理的策略
   OBJC_ASSOCIATION_ASSIGN 等价于 @property(assign)。
   OBJC_ASSOCIATION_RETAIN_NONATOMIC等价于 @property(strong, nonatomic)。
   OBJC_ASSOCIATION_COPY_NONATOMIC等价于@property(copy, nonatomic)。
   OBJC_ASSOCIATION_RETAIN等价于@property(strong,atomic)。
   OBJC_ASSOCIATION_COPY等价于@property(copy, atomic)。
 
   void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)  //关联对象
   id objc_getAssociatedObject(id object, const void *key) //获取关联的对象
   void objc_removeAssociatedObjects(id object)  //移除关联的对象
   */
- (void)setPhone:(NSString *)phone{
    /*
     set方法，将值value 跟对象object 关联起来（将值value 存储到对象object 中）
     参数 object：给哪个对象设置属性
     参数 key：一个属性对应一个Key，将来可以通过key取出这个存储的值，key 可以是任何类型：double、int等，建议用char 可以节省字节
     参数 value：给属性设置的值
     参数policy：存储策略 （assign 、copy 、 retain就是strong）
    */
    objc_setAssociatedObject(self, &kDefaultNameKey, phone, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)phone{
    //利用参数key 将对象person中存储的对应值取出来
    return objc_getAssociatedObject(self, &kDefaultNameKey);
}





@end
