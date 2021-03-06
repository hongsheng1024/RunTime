//
//  FunViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/25.
//  Copyright © 2018 whs. All rights reserved.
//

#import "FunViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "Person+DefaultOJ.h"
#import "TestObj.h"

@interface FunViewController ()

@property(nonatomic, strong)TestObj *objs;

@property(nonatomic, assign)CGFloat  counts;

@end

@implementation FunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_atIndex == 0) {
        [self sendMsg];
    }else if (_atIndex == 1){
        [self exchangeMethod];
    }else if (_atIndex == 2){
        [self addMethod];
    }else if (_atIndex == 3){
        [self getClassMsg];
    }else if (_atIndex == 4){
        [self addPropertyForCategory];
    }else if (_atIndex == 5){
        [self testForKVC];
    }else if (_atIndex == 6){
        [self TestForKVO];
    }else if (_atIndex == 7){
        [self blockProduct];
    }
    
    
    
    
}

#pragma mark - 使用objc_msgSend发送消息
- (void)sendMsg{
    Person *p = [[Person alloc]init];
    p.name = @"小明";
    p.address = @"北京市";
    /*
     消息机制原理：对象根据方法编号SEL去映射表查找对应的方法实现
     参数1: 消息接收的对象实例
     参数2: 要执行的方法
     */
    objc_msgSend(p, @selector(getInformation));
    //调用类方法
    objc_msgSend([Person class], @selector(study));
}
#pragma mark - Runtime交换方法实现
- (void)exchangeMethod{
    Person *p = [[Person alloc]init];
    p.name = @"小明";
    p.address = @"北京市";
    //获取方法地址
    Method hEat = class_getInstanceMethod([Person class], @selector(eat));
    Method hPlay = class_getInstanceMethod([Person class], @selector(play));
    //交换方法地址，相当于交换实现方式
    method_exchangeImplementations(hEat, hPlay);
    objc_msgSend(p, @selector(eat));  //paly == 去跑步
    
    //Method hSleep = class_getClassMethod([Person class], @selector(sleep));
    //Method hStudy = class_getClassMethod([Person class], @selector(study));
    //method_exchangeImplementations(hSleep, hStudy);
    //objc_msgSend([Person class], @selector(sleep));  //study == 去学习
}

#pragma mark - 动态添加方法
- (void)addMethod{
    Person *p= [[Person alloc]init];
    [p performSelector:@selector(buy)];
}

#pragma mark - runtime获取类的一些信息
- (void)getClassMsg{
    
    /*
      * 相关定义
        typedef struct objc_method *Method;  //描述类中的一个方法
        typedef struct objc_ivar *Ivar; //实例变量
        typedef struct objc_category *Category; //类别Category
        typedef struct objc_property *objc_property_t; //类中声明的属性
    */
   
    //获取属性列表
     unsigned int count01;
    objc_property_t *propertyList = class_copyPropertyList([Person class], &count01);
    for (unsigned int i = 0; i < count01; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"属性---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    //获取方法列表
    unsigned int count02;
    Method *methodList = class_copyMethodList([Person class], &count02);
    for (unsigned int i = 0; i < count02; i++) {
        Method method = methodList[i];
        NSLog(@"方法---->%@", NSStringFromSelector(method_getName(method)));
    }
    
    //获取成员变量列表
    unsigned int count03;
    Ivar *ivarList = class_copyIvarList([Person class], &count03);
    for (unsigned int i = 0; i < count03; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"成员变量---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    unsigned int count04;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([Person class], &count04);
    for (unsigned int i = 0; i < count04; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"协议---->%@", [NSString stringWithUTF8String:protocolName]);
    }
}

#pragma mark - 关联对象给分类增加属性
- (void)addPropertyForCategory{
    Person *p = [[Person alloc]init];
    p.phone = @"1234321";
    NSLog(@"电话: %@", p.phone);
}

//参考 https://www.jianshu.com/p/b9f020a8b4c9
#pragma mark - KVC
- (void)testForKVC{
    TestObj *obj = [[TestObj alloc]init];
    [obj setValue:@"小明" forKey:@"name"];
    NSString *name = [obj valueForKey:@"name"];
}

#pragma mark - KVO
- (void)TestForKVO{
    self.objs = [[TestObj alloc]init];
    //self.objs.phone = @"1234";
    //此行注册监听后，objs由TestObj类变成NSKVONotyfing_TestObj类。
    [self.objs addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@监听到%@属性的改变为%@", object, keyPath, change[@"new"]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //self.objs.phone = @"kvo实现啦";
    //self.objs.age = 10;
    [self.objs setValue:@"达州" forKey:@"name"];
}

- (void)dealloc{
    [self.objs removeObserver:self forKeyPath:@"phone"];
}

/***************************** Block ***********************************/
- (void)blockProduct{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
