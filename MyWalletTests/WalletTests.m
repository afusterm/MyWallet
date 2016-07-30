//
//  WalletTests.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Money.h"
#import "Broker.h"
#import "Wallet.h"

@interface WalletTests : XCTestCase
@property (nonatomic, strong) Wallet *wallet;

@end

@implementation WalletTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.wallet = [[Wallet alloc] initWithAmount:10 currency:@"USD"];
    [self.wallet plus:[Money euroWithAmount:5]];
    [self.wallet plus:[[Money alloc] initWithAmount:5 currency:@"JPY"]];
    [self.wallet plus:[Money euroWithAmount:5]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.wallet = nil;
}

// €40 + 20$ = $100 con una tasa 2:1
-(void) testAdditionWithReduction {
    Broker *broker = [Broker new];
    [broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];
    
    Wallet *wallet = [[Wallet alloc] initWithAmount:40 currency:@"EUR"];
    [wallet plus: [Money dollarWithAmount:20]];
    
    Money *reduced = [broker reduce:wallet toCurrency:@"USD"];
    
    XCTAssertEqualObjects(reduced, [Money dollarWithAmount:100], @"€40 + $20 = $100 2:1");
}

-(void) testReductionFromWallet {
    Wallet *wallet = [[Wallet alloc] initWithAmount:20 currency:@"USD"];
    [wallet plus:[Money euroWithAmount:10]];
    Broker *broker = [Broker new];
    [broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];
    Money *reduced = [wallet reduceToCurrency:@"USD" withBroker:broker];
    
    XCTAssertEqualObjects(reduced, [Money dollarWithAmount:40], @"$20 + €10 = $40 2:1");
}

-(void) testHowManyCurrencies {
    XCTAssertEqual([self.wallet currencies], 3, @"The wallet must have 3 currencies (USD, EUR, JPY");
}

-(void) testMoneysAtCurrency {
    NSArray *moneys = [self.wallet moneysAtCurrency:1];
    XCTAssertEqual(2, [moneys count], @"There must be 2 moneys of EUR in the second currency");
}

-(void) testTotalAmountForCurrency {
    NSUInteger total = [self.wallet totalAmountForCurrency:@"EUR"];
    XCTAssertEqual(10, total, @"The total amount for euros currency must be 10");
}

-(void) testTake20EurosFromWalletWith40 {
    Wallet *w = [[Wallet alloc] initWithAmount:20 currency:@"EUR"];
    [w plus:[Money euroWithAmount:20]];
    
    Money *m = [Money euroWithAmount:20];
    [w takeMoney:m];
    
    XCTAssertEqual(20, [w totalAmountForCurrency:@"EUR"], @"The wallet has to have 20 EUR");
}

-(void) testTake10EurosFromWalletWith20And5 {
    Wallet *w = [[Wallet alloc] initWithAmount:20 currency:@"EUR"];
    [w plus:[Money euroWithAmount:5]];
    [w takeMoney:[Money euroWithAmount:10]];
    NSUInteger amountInWallet = [w totalAmountForCurrency:@"EUR"];
    
    XCTAssertNotEqual(15, amountInWallet, @"The amount in the wallet can't be €15");
    XCTAssertEqual(25, amountInWallet, @"The amount in the wallet must be €25");
}

-(void) testThatWeCantTake10EurosInAWalletWith5 {
    Wallet *w = [[Wallet alloc] initWithAmount:5 currency:@"EUR"];
    XCTAssertFalse([w takeMoney:[Money euroWithAmount:10]], @"We can't take €10 in a wallet with €5");
}

@end
