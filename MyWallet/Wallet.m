//
//  Wallet.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Wallet.h"

@interface Wallet()
@property (nonatomic, strong) NSMutableArray *moneys;
@property (nonatomic, strong) NSMutableDictionary *currenciesDict;
@end

@implementation Wallet

-(id) initWithAmount:(NSInteger) amount currency:(NSString*) currency {
    if (self = [super init]) {
        Money *money = [[Money alloc] initWithAmount:amount currency:currency];
        _moneys = [NSMutableArray array];
        [_moneys addObject:money];
        
        _currenciesDict = [NSMutableDictionary dictionary];
        NSMutableArray *m = [NSMutableArray array];
        [m addObject:money];
        [_currenciesDict setObject:m forKey:[money currency]];
    }
    
    return self;
}

-(id<Money>)plus:(Money*) money {
    [self.moneys addObject:money];
    
    // obtener el número de moneys de la divisa
    NSMutableArray *m = [self.currenciesDict objectForKey:[money currency]];
    
    if (m == nil) {
        m = [NSMutableArray array];
        [self.currenciesDict setObject:m forKey:money.currency];
    }
    
    [m addObject:money];
    
    return self;
}

-(id<Money>) times:(NSInteger) multiplier {
    NSMutableArray *newMoneys = [NSMutableArray arrayWithCapacity:self.moneys.count];
    
    for (Money *each in self.moneys) {
        Money *newMoney = [each times:multiplier];
        [newMoneys addObject:newMoney];
    }
    
    self.moneys = newMoneys;
    return self;
}

-(id<Money>) reduceToCurrency:(NSString *) currency withBroker:(Broker*) broker {
    Money *result = [[Money alloc] initWithAmount:0 currency:currency];
    
    for (Money *each in self.moneys) {
        result = [result plus:[each reduceToCurrency:currency withBroker:broker]];
    }
    
    return result;
}

#pragma mark - Properties

-(NSUInteger) count {
    return [self.moneys count];
}

-(NSUInteger) currencies {
    return [[self.currenciesDict allKeys] count];
}

#pragma mark - Query methods

-(NSArray *) moneysAtCurrency:(NSUInteger) index {
    NSString *key = [[self.currenciesDict allKeys] objectAtIndex:index];
    return [self.currenciesDict objectForKey:key];
}

-(NSUInteger) totalAmountForCurrency:(NSString *) currency {
    NSArray *moneys = [self.currenciesDict objectForKey:currency];
    NSUInteger total = 0;
    
    // calcular el total
    for (Money *money in moneys) {
        total += [money.amount integerValue];
    }
    
    return total;
}

-(NSString *) currencyAtIndex:(NSUInteger) index {
    return [[self.currenciesDict allKeys] objectAtIndex:index];
}

#pragma mark - Notifications

-(void) subscribeToMemoryWarning:(NSNotificationCenter *) nc {
    [nc addObserver:self
           selector:@selector(dumpToDisk:)
               name:UIApplicationDidReceiveMemoryWarningNotification
             object:nil];
}

-(void) dumpToDisk:(NSNotificationCenter *) notification {
    
}

@end
