//
//  ControllerTests.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SimpleViewController.h"
#import "WalletTableViewController.h"
#import "Wallet.h"
#import "Broker.h"

@interface ControllerTests : XCTestCase
@property (nonatomic, strong) SimpleViewController *simpleVC;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) WalletTableViewController *walletVC;
@property (nonatomic, strong) Wallet *wallet;
@property (nonatomic, strong) Broker *broker;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.simpleVC = [[SimpleViewController alloc] initWithNibName:nil bundle:nil];
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"Hola" forState:UIControlStateNormal];
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.simpleVC.displayLabel = self.label;
    
    self.wallet = [[Wallet alloc] initWithAmount:1 currency:@"USD"];
    [self.wallet plus:[Money euroWithAmount:1]];
    [self.wallet plus:[[Money alloc] initWithAmount:5 currency:@"JPY"]];
    [self.wallet plus:[Money euroWithAmount:10]];
    
    // tasas de conversión
    self.broker = [Broker new];
    [self.broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];
    [self.broker addRate:4 fromCurrency:@"EUR" toCurrency:@"JPY"];
    [self.broker addRate:2 fromCurrency:@"USD" toCurrency:@"JPY"];
    
    self.walletVC = [[WalletTableViewController alloc] initWithModel:self.wallet broker:self.broker];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    // lo destruimos
    self.simpleVC = nil;
    self.button = nil;
    self.label = nil;
}

-(void) testThatTextOnLabelIsEqualToTextOnButton {
    // mandamos el mensaje
    [self.simpleVC displayText:self.button];
    
    // comprobamos que etiqueta y botón tienen el mismo texto
    XCTAssertEqualObjects(self.button.titleLabel.text, self.label.text,
                          @"Button and label should have the same text");
}

-(void) testThatNumberOfCellsIsNumberOfMoneysPlusOne {
    XCTAssertEqual(2,
                   [self.walletVC tableView:self.tableView numberOfRowsInSection:0],
                   @"Number of cells in the first section is 2 ($1 and the total");
}

-(void) testThatTableHasTheNeededSections {
    NSUInteger sections = [self.walletVC numberOfSectionsInTableView:self.tableView];
    
    XCTAssertEqual(sections, 4, @"The number of sections must be three (Dollars, Euros, Yen and Total");
}

-(void) testThatTableWithEmptyWalletHasOneSection {
    Wallet *w = [Wallet new];
    Broker *b = [Broker new];
    WalletTableViewController *vc = [[WalletTableViewController alloc] initWithModel:w broker:b];
    
    XCTAssertEqual(1, [vc tableView:self.tableView numberOfRowsInSection:0],
                   @"The number of sections in an empty wallet must be 1 (the total)");
}

-(void) testThatTheNumberOfCellsInSectionIsNumberOfMoneysAtCurrency {
    XCTAssertEqual(3, [self.walletVC tableView:self.tableView numberOfRowsInSection:1],
                   @"In the second section (EUR) must be three cells (€1, €10 and total");
}

-(void) testThatTheNumberOfCellsInLastSectionIsOne {
    XCTAssertEqual(1, [self.walletVC tableView:self.tableView numberOfRowsInSection:3]);
}

-(void) testTextInCell {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.walletVC tableView:self.tableView
                               cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(@"1 USD", cell.textLabel.text, @"The first cell in the first section must be 1 USD");
    
    // comprobar el total de la primera divisa
    path = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.walletVC tableView:self.tableView
              cellForRowAtIndexPath:path];
    
    XCTAssertEqualObjects(@"1 USD", cell.textLabel.text, @"The first cell in the first section must be 1 USD");
}

-(void) testTotalCell {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3];
    UITableViewCell *cell = [self.walletVC tableView:self.tableView
                               cellForRowAtIndexPath:path];
    
    XCTAssertEqualObjects(@"12 EUR", cell.textLabel.text, @"The cell in the last section must be 12 USD");
}

-(void) testTitleHeaderInSection {
    NSString *currency = [self.wallet currencyAtIndex:0];
    XCTAssertEqualObjects(@"USD", currency, @"The first currency must be USD");
    
    XCTAssertEqualObjects(@"Total", [self.walletVC tableView:self.tableView titleForHeaderInSection:3],
                          @"The last section must have the title Total");
}

@end
