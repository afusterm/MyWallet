//
//  Wallet.h
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Money.h"

@interface Wallet : NSObject<Money>

@property (nonatomic, readonly) NSUInteger count;

-(id) initWithAmount:(NSInteger) amount currency:(NSString*) currency;

-(void) subscribeToMemoryWarning:(NSNotificationCenter *) nc;

@end
