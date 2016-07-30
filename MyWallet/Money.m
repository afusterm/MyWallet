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

/**
 *  Crea un objeto Money en la divisa EUR.
 *
 *  @param amount Cantidad de dinero en euros.
 *  @return Nuevo objeto Money en euros.
 */
+(id) euroWithAmount:(NSInteger) amount {
    return [[Money alloc] initWithAmount:amount currency:@"EUR"];
}

/**
 *  Crea un objeto Money en la divisa USD.
 *
 *  @param amount Cantidad de dinero en dólares.
 *  @return Nuevo objeto Money en dólares.
 */
+(id) dollarWithAmount:(NSInteger) amount {
    return [[Money alloc] initWithAmount:amount currency:@"USD"];
}

/**
 *  Crea un objeto Money con la cantidad y divisa indicadas.
 *
 *  @param amount Cantidad de dinero.
 *  @param currency Divisa del dinero.
 *  @return Nuevo objeto Money con la cantidad y divisa indicadas.
 */
-(id) initWithAmount:(NSInteger) amount currency:(NSString *) currency {
    if (self = [super init]) {
        _amount = @(amount);
        _currency = currency;
    }
    
    return self;
}

/**
 *  Multiplica el dinero por el parámetro pasado.
 *
 *  @param multiplier Cantidad por la que se desea multiplicar el dinero.
 *  @return Nuevo objeto Money con el resultado de la operación.
 */
-(id<Money>) times:(NSInteger) multiplier {
    Money *newMoney = [[Money alloc]
                       initWithAmount:[self.amount integerValue] * multiplier currency:self.currency];
    return newMoney;
    
}

/**
 *  Suma otro objeto Money al actual y devuelve el resultado en un nuevo objeto.
 *
 *  @param other Objeto Money que se quiere sumar.
 *  @return Nuevo objeto Money con el resultado.
 */
-(id<Money>) plus:(Money *) other {
    NSInteger totalAmount = [self.amount integerValue] + [other.amount integerValue];
    Money *total = [[Money alloc] initWithAmount:totalAmount
                                        currency:self.currency];
    
    return total;
}

/**
 *  Convierte el dinero del objeto Money a la divisa indicada utilizando la tasa de
 *  conversión del objeto broker.
 *
 *  @param currency Divisa a la que se quiere convertir.
 *  @param broker Broker que contiene la tasa de conversión de una divisa a otra.
 *  @return Nuevo objeto Money con el dinero equivalente en la nueva divisa.
 */
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

/**
 *  @return Cadena descriptiva con la forma: <Money: Divisa Cantidad>
 */
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
