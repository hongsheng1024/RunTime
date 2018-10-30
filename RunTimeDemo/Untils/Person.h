//
//  Person.h
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/25.
//  Copyright © 2018 whs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic, strong)NSString *name;  //名字
@property(nonatomic, strong)NSString *address; //住址

//方法
- (void)getInformation;
- (void)play;
- (void)eat;
+ (void)study;
+ (void)sleep;


@end
