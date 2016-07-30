//
//  WalletTableViewController.m
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "WalletTableViewController.h"
#import "Wallet.h"

@interface WalletTableViewController ()
@property (nonatomic, strong) Wallet *model;
@property (nonatomic, strong) Broker *broker;
@end

@implementation WalletTableViewController

-(id) initWithModel:(Wallet *) model broker:(Broker *) broker {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _model = model;
        _broker = broker;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // una sección por divisa más el total
    return [self.model currencies] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.model.currencies) {
        // la última sección solo tiene una fila
        return 1;
    }
    
    // uno por cada money más el total
    return [[self.model moneysAtCurrency:section] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MoneyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    Money *money = nil;
    
    if (indexPath.section == self.model.currencies) {
        // última sección, la del total
        money = [self.model reduceToCurrency:@"EUR" withBroker:self.broker];
        cell.textLabel.text = [[[money.amount description] stringByAppendingString:@" "]
                               stringByAppendingString:money.currency];
        
    } else {
        NSArray *moneys = [self.model moneysAtCurrency:indexPath.section];
        
        if (indexPath.row == moneys.count) {
            // última celda, la del subtotal de la divisa
            money = [moneys firstObject];
            NSNumber *total = [NSNumber numberWithInt:[self.model totalAmountForCurrency:money.currency]];
            cell.textLabel.text = [[[total description] stringByAppendingString:@" "]
                                   stringByAppendingString:money.currency];
            cell.detailTextLabel.text = @"Subtotal";
        } else  {
            // cualquier otra celda
            money = [moneys objectAtIndex:indexPath.row];
            cell.textLabel.text = [[[money.amount description] stringByAppendingString:@" " ]
                                   stringByAppendingString:money.currency];
        }
    }
    
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section >= self.model.currencies) {
        return @"Total";
    }
    
    return [self.model currencyAtIndex:section];
}


@end
