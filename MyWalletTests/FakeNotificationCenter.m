//
//  FakeNotificationCenter.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "FakeNotificationCenter.h"

@implementation FakeNotificationCenter

-(id) init {
    if (self = [super init]) {
        _observers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(void) addObserver:(nonnull id) observer
           selector:(nonnull SEL)aSelector
               name:(nullable NSString *)aName
             object:(nullable id)anObject {
    [self.observers setObject:observer
                       forKey:aName];
}

@end
