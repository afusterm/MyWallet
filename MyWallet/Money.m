//
//  Money.m
//  MyWallet
//
//  Created by Alejandro on 20/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "Money.h"
#import "NSObject+GNUStepAddons.h"
#import "Broker.h"

@interface Money()
@property (nonatomic, strong) NSNumber *amount;
@end


@implementation Money

+(id) euroWithAmount:(NSInteger) amount {
    return [[Money alloc] initWithAmount:amount currency:@"EUR"];
}

+(id) dollarWithAmount:(NSInteger) amount {
    return [[Money alloc] initWithAmount:amount currency:@"USD"];
}

-(id) initWithAmount:(NSInteger) amount currency:(NSString *) currency {
    if (self = [super init]) {
        _amount = @(amount);
        _currency = currency;
    }
    
    return self;
}

-(id<Money>) times:(NSInteger) multiplier {
    Money *newMoney = [[Money alloc]
                       initWithAmount:[self.amount integerValue] * multiplier currency:self.currency];
    return newMoney;
    
}

-(id<Money>) plus:(Money *) other {
    NSInteger totalAmount = [self.amount integerValue] + [other.amount integerValue];
    Money *total = [[Money alloc] initWithAmount:totalAmount
                                        currency:self.currency];
    
    return total;
}

-(id<Money>) reduceToCurrency:(NSString *) currency withBroker:(Broker*) broker {
    Money *result;
    double rate = [[broker.rates objectForKey:[broker keyFromCurrency:self.currency
                                                       toCurrency:currency]] doubleValue];
    
    // comprobamos que divisa de origen y de destino son las mismas
    if ([self.currency isEqual:currency]) {
        result = self;
    } else if (rate == 0) {
        // no hay tasa de conversión, excepción que te crió
        [NSException raise:@"NoConversionRateException"
                    format:@"Must have a conversion from %@ to %@", self.currency, currency];
    } else {
        // tenemos conversión
        NSInteger newAmount = [self.amount integerValue] * rate;
        result = [[Money alloc] initWithAmount:newAmount currency:currency];
    }
    
    
    return result;
}

#pragma mark - OVerwritten

-(NSString *) description {
    return [NSString stringWithFormat:@"<%@: %@ %@>", [self class], self.currency, self.amount];
}

-(BOOL) isEqual:(id)object {
    if ([self.currency isEqual:[object currency]]) {
        return [[self amount] integerValue] == [[object amount] integerValue];
    } else {
        return NO;
    }
}

-(NSUInteger) hash {
    return [self.amount integerValue];
}

@end
