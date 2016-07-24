//
//  FakeNotificationCenter.h
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeNotificationCenter : NSObject

@property (nonatomic, strong, nullable) NSMutableDictionary *observers;

-(void) addObserver:(nonnull id) observer
           selector:(nonnull SEL)aSelector
               name:(nullable NSString *)aName
             object:(nullable id)anObject;

@end
