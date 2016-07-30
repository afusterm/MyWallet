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
@property (nonatomic, strong) NSMutableDictionary *currenciesDict;
@end

@implementation Wallet

/**
 *  Crea un objeto Wallet con el dinero y la divisa indicada.
 *
 *  @param amount Cantidad de dinero que contendrá el nuevo objeto Wallet.
 *  @param currency Divisa del objeto Money contenido en el nuevo Wallet.
 *  @return Nuevo objeto Wallet.
 */
-(id) initWithAmount:(NSInteger) amount currency:(NSString*) currency {
    if (self = [super init]) {
        Money *money = [[Money alloc] initWithAmount:amount currency:currency];
        
        _currenciesDict = [NSMutableDictionary dictionary];
        NSMutableArray *m = [NSMutableArray array];
        [m addObject:money];
        [_currenciesDict setObject:m forKey:[money currency]];
    }
    
    return self;
}

/**
 *  Añade un objeto Money al objeto Wallet.
 *
 *  @param money Objeto Money que se añade al objeto Wallet.
 *  @return Objeto Wallet con el objeto money añadido.
 */
-(id<Money>)plus:(Money*) money {
    // obtener los moneys de la divisa
    NSMutableArray *m = [self.currenciesDict objectForKey:money.currency];
    
    if (m == nil) {
        // si no existen moneys para la divisa se crea un array
        m = [NSMutableArray array];
        [self.currenciesDict setObject:m forKey:money.currency];
    }
    
    [m addObject:money];
    
    return self;
}

/**
 *  Multiplica todos los objetos Money contenidos en el objeto Wallet por el parámetro
 *  indicado en times, devolviendo el objeto Wallet con el resultado.
 *
 *  @param multiplier Cantidad por la que se multiplicará cada uno de los objetos Money de Wallet.
 *  @return Objeto Wallet con el resultado.
 */
-(id<Money>) times:(NSInteger) multiplier {
    // crear el nuevo diccionario de arrays
    NSMutableDictionary *newCurrenciesDict = [NSMutableDictionary dictionary];
    
    for (NSString *currency in self.currenciesDict.allKeys) {
        // obtener los moneys de la divisa en el actual diccionario de divisas
        NSArray *moneys = [self.currenciesDict objectForKey:currency];
        
        // recorrer todos los moneys de la divisa
        for (Money *money in moneys) {
            Money *newMoney = [money times:multiplier];
            
            // obtener los moneys de la divisa del nuevo diccionario y añadir el nuevo money
            NSMutableArray *newMoneys = [newCurrenciesDict objectForKey:currency];
            if (newMoneys == nil) {
                // si no existe la divisa en el nuevo diccionario de divisas, se crea
                newMoneys = [NSMutableArray array];
                [newCurrenciesDict setObject:newMoneys forKey:currency];
            }
            
            [newMoneys addObject:newMoney];
        }
    }
    
    self.currenciesDict = newCurrenciesDict;
    
    return self;
}

/**
 *  Convierte la cantidad de dinero que hay en el objeto Wallet a la divisa indicada y devuelve
 *  esa cantidad en otro objeto Money.
 *
 *  @param currency Divisa a la que se quiere convertir el dinero del objeto Wallet.
 *  @param broker Objeto broker que realizará la conversión.
 *  @return Nuevo objeto Money que contendrá el dinero en la divisa indicada.
 */
-(id<Money>) reduceToCurrency:(NSString *) currency withBroker:(Broker*) broker {
    Money *result = [[Money alloc] initWithAmount:0 currency:currency];
    for (NSString *eachCurrency in self.currenciesDict.allKeys) {
        NSArray *moneys = [self.currenciesDict objectForKey:eachCurrency];
        
        for (Money *money in moneys) {
            result = [result plus:[money reduceToCurrency:currency withBroker:broker]];
        }
    }
    
    return result;
}

/**
 *  Retira un objeto Money del objeto Wallet. Solo puede retirarlo si hay un objeto Money
 *  igual al indicado, aunque la cantidad de dinero sea superior a la cantidad del objeto
 *  Money. Ej: Si hay un objeto con 5€ y otro con 20€ y se quiere retirar un objeto Money
 *  de 10€ no se podrá retirar.
 *
 *  @param money Objeto Money que se quiere retirar del objeto Wallet.
 *  @return TRUE si se eliminó el objeto Money del objeto Wallet.
 *  @return FALSE si no se pudo eliminar el objeto Money del objeto Wallet.
 */
-(BOOL) takeMoney:(Money *) money {
    // eliminar del diccionario de arrays de moneys
    NSMutableArray *moneysWithCurrency = [self.currenciesDict objectForKey:money.currency];
    return [self removeFirstOccurrence:money from:moneysWithCurrency];
}

#pragma mark - Properties

/**
 *  @return Número de objetos Money disponibles en el objeto Wallet.
 */
-(NSUInteger) count {
    NSUInteger count = 0;
    
    for (NSString *currency in self.currenciesDict.allKeys) {
        NSArray *moneys = [self.currenciesDict objectForKey:currency];
        count += moneys.count;
    }
    
    return count;
}

/**
 *  @return Número de divisas disponible en el objeto Wallet.
 */
-(NSUInteger) currencies {
    return [[self.currenciesDict allKeys] count];
}

#pragma mark - Query methods

/**
 *  Obtiene la cantidad de objetos money existentes para la divisa que ocupa la posición index.
 *
 *  @param index Posición de la divisa.
 *  @return Número de objetos money.
 */
-(NSArray *) moneysAtCurrency:(NSUInteger) index {
    NSString *key = [[self.currenciesDict allKeys] objectAtIndex:index];
    return [self.currenciesDict objectForKey:key];
}

/**
 *  Obtiene la suma de dinero disponible en el objeto Wallet para una divisa dada.
 *
 *  @param currency Divisa de la cual se quiere conocer la cantidad disponible.
 *  @return Dinero total disponible en la divisa.
 */
-(NSUInteger) totalAmountForCurrency:(NSString *) currency {
    NSArray *moneys = [self.currenciesDict objectForKey:currency];
    NSUInteger total = 0;
    
    // calcular el total
    for (Money *money in moneys) {
        total += [money.amount integerValue];
    }
    
    return total;
}

/**
 *  Obtiene la divisa a partir de la posición que ocupa en Wallet. 
 *
 *  @param index Posición de la divisa en Wallet.
 *  @return Divisa contenida en Wallet en la posición index.
 */
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

#pragma mark - Utils

/**
 *  Elimina la primera ocurrencia del objeto en el array. El método removeObject
 *  elimina todas las ocurrencias del objeto indicado.
 *
 *  @param object Objeto a eliminar del array.
 *  @param array Array del cual se eliminará el objeto object.
 */
-(BOOL) removeFirstOccurrence:(id) object from:(NSMutableArray *) array {
    BOOL removed = FALSE;
    
    for (int i = 0; i < array.count; i++) {
        id obj = [array objectAtIndex:i];
        if ([obj isEqual:object]) {
            [array removeObjectAtIndex:i];
            removed = TRUE;
            
            break;
        }
    }
    
    return removed;
}

@end
