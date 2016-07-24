//
//  MoneyTests.m
//  MyWallet
//
//  Created by Alejandro on 20/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Money.h"

@interface MoneyTests : XCTestCase

@end

@implementation MoneyTests

-(void) testSimpleMultiplication {
    Money *euro = [Money euroWithAmount: 5];
    Money *ten = [Money euroWithAmount:10];
    Money *total = [euro times: 2];
    
    XCTAssertEqualObjects(total, ten, @"€5 * 2 should be €10");
}

-(void) testEquality {
    Money *five = [Money euroWithAmount:5];
    Money *ten = [Money euroWithAmount:10];
    Money *total = [five times:2];
    
    XCTAssertEqualObjects(ten, total, @"Equivalent objects should be equal!");
    XCTAssertEqualObjects([Money dollarWithAmount:4], [[Money dollarWithAmount:2] times:2],
                          @"Equivalent objects should be equal!");
}

-(void) testDifferentCurrencies {
    Money *euro = [Money euroWithAmount:1];
    Money *dollar = [Money dollarWithAmount:1];
    
    XCTAssertNotEqualObjects(euro, dollar, @"Different currencies should not be equal!");
}

-(void) testHash {
    Money *a = [Money euroWithAmount:2];
    Money *b = [Money euroWithAmount:2];
    
    XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");
    XCTAssertEqual([[Money dollarWithAmount:1] hash],
                   [[Money dollarWithAmount:1] hash], @"Equal objects must have same hash");
}

-(void) testAmountStorage {
    Money *euro = [Money euroWithAmount:2];
    
    // pragmas para ignorar el warning al llamar a un selector que no existe en la interfaz pública
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(2, [[euro performSelector:@selector(amount)] integerValue], @"The value retrieved should be the same as the stored");
    XCTAssertEqual(2, [[[Money dollarWithAmount:2] performSelector:@selector(amount)] integerValue],
                   @"The value retrieved should be the same as the storage");
#pragma clang diagnostic pop
}

-(void) testCurrencies {
    XCTAssertEqualObjects(@"EUR", [[Money euroWithAmount:1] currency],
                          @"The currency of euros should be EUR");
    XCTAssertEqualObjects(@"USD", [[Money dollarWithAmount:1] currency],
                          @"The currency of $1 should be USD");
}

-(void) testSimpleAddition {
    XCTAssertEqualObjects([[Money dollarWithAmount:5] plus: [Money dollarWithAmount:5]],
                          [Money dollarWithAmount:10], @"$5 + $5 = $10");
}

-(void) testThatHashIsAmount {
    Money *one = [Money dollarWithAmount:1];
    
    XCTAssertEqual([one hash], 1, @"The hash must be the same as the amount");
}

-(void) testDescription {
    Money *one = [Money dollarWithAmount:1];
    NSString *desc = @"<Money: USD 1>";
    
    XCTAssertEqualObjects(desc, [one description], @"Description match template");
}

@end
