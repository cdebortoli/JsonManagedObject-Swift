//
//  JMOClassFactory.h
//  JsonManagedObject-Swift
//
//  Created by christophe on 12/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//
#import <objc/runtime.h>

@interface JMOClassFactory:NSObject

+ (id)initObjectFromClass:(Class)classObject;

@end