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

/**
 *  Crea un nuevo objeto Broker.
 *
 *  @return Nuevo objeto Broker.
 */
-(id) init {
    if (self = [super init]) {
        _rates = [@{} mutableCopy];
    }
    
    return self;
}

/**
 *  Envía el mensaje reduce al objeto que implementa Money.
 *
 *  @param money Objeto que implementa el protocolo Money al que se le reenviará el mensaje reduce.
 *  @param currency Divisa del objeto Money.
 *  @return Objeto que implementa Money que devuelve el mensaje enviado a money.
 */
-(id<Money>) reduce:(id<Money>) money
       toCurrency:(NSString *) currency {
    
    // double dispath
    return [money reduceToCurrency:currency withBroker:self];
}

/**
 *  Añade un ratio de conversión.
 *
 *  @param rate Ratio de conversión.
 *  @param Divisa que se va a convertir.
 *  @param Divisa a la que se va a convertir la divisa origen.
 */
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

#pragma mark - Rates

-(void) parseJSONRates:(NSData *) json {
    NSError *err = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:json
                                             options:NSJSONReadingAllowFragments
                                               error:&err];
    if (obj != nil) {
        // pillamos los rates y los vamos añadiendo al broker
        
    } else {
        // no hemos recibido nada: la cagamos
        [NSException raise:@"NoRatesInJSONException"
                    format:@"JSON must carry some data!"];
    }
}

@end
