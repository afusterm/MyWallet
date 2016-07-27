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

@interface ControllerTests : XCTestCase
@property (nonatomic, strong) SimpleViewController *simpleVC;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) WalletTableViewController *walletVC;
@property (nonatomic, strong) Wallet *wallet;
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
    self.walletVC = [[WalletTableViewController alloc] initWithModel:self.wallet];
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

-(void) testThatTableWithEmptyWalleHasOneSection {
    Wallet *w = [Wallet new];
    WalletTableViewController *vc = [[WalletTableViewController alloc] initWithModel:w];
    
    XCTAssertEqual(1, [vc tableView:self.tableView numberOfRowsInSection:0],
                   @"The number of sections in an empty wallet must be 1 (the total)");
}

-(void) testThatTheNumberOfCellsInSectionIsNumberOfMoneysAtCurrency {
    XCTAssertEqual(3, [self.walletVC tableView:self.tableView numberOfRowsInSection:1],
                   @"In the second section (EUR) must be three cells (€1, €10 and total");
}

@end
