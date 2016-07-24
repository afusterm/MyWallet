//
//  NSObject+GNUStepAddons.m
//  MyWallet
//
//  Created by Alejandro on 20/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+GNUStepAddons.h"

// NOTE: esto ya no hace falta. Se deja para saber cómo se hace.

@implementation NSObject (GNUStepAddons)

-(id) subclassResponsability:(SEL)aSel {
    char prefix = class_isMetaClass(object_getClass(self)) ? '+': '-';
    
    [NSException raise:NSInvalidArgumentException
                format:@"%@%c%@ should be overriden by its subclass",
     NSStringFromClass([self class]), prefix, NSStringFromSelector(aSel)];
    
    return self;    // not reached
}

@end
