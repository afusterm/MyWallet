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

-(void) testThatTableHasOneSection {
    // no es necesario pasar una tabla al controlador. Solo queremos saber cuántas
    // secciones vamos a meter.
    NSUInteger sections = [self.walletVC numberOfSectionsInTableView:self.tableView];
    
    XCTAssertEqual(sections, 1, @"There can only be one");
}

-(void) testThatNumberOfCellsIsNumberOfMoneysPlusOne {
    XCTAssertEqual(self.wallet.count + 1,
                   [self.walletVC tableView:self.tableView numberOfRowsInSection:0],
                   @"Number of cells is the number of moneys plus 1 (the total)");
}

@end
