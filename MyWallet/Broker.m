//
//  Broker.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "Broker.h"

@interface Broker()

@end

@implementation Broker

-(id) init {
    if (self = [super init]) {
        _rates = [@{} mutableCopy];
    }
    
    return self;
}

-(id<Money>) reduce:(id<Money>) money
       toCurrency:(NSString *) currency {
    
    // double dispath
    return [money reduceToCurrency:currency withBroker:self];
}

-(void) addRate:(NSInteger) rate
   fromCurrency:(NSString *) fromCurrency
     toCurrency:(NSString *) toCurrency {
    
    [self.rates setObject:@(rate)
                   forKey:[self keyFromCurrency:fromCurrency toCurrency:toCurrency]];
    
    [self.rates setObject:@(1.0/rate)
                   forKey:[self keyFromCurrency:toCurrency toCurrency:fromCurrency]];
}

#pragma mark - Utils

-(NSString *) keyFromCurrency:(NSString *) fromCurrency
                   toCurrency:(NSString *) toCurrency {
    return [NSString stringWithFormat:@"%@-%@", fromCurrency, toCurrency];
}

@end