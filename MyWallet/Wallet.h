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
@property (nonatomic, readonly) NSUInteger currencies;

-(id) initWithAmount:(NSInteger) amount currency:(NSString*) currency;

-(void) subscribeToMemoryWarning:(NSNotificationCenter *) nc;

-(NSArray *) moneysAtCurrency:(NSUInteger) index;

-(NSUInteger) totalAmountForCurrency:(NSString *) currency;

-(NSString *) currencyAtIndex:(NSUInteger) index;

-(BOOL) takeMoney:(Money *) money;

@end
