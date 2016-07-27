//
//  WalletTableViewController.h
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wallet;
@class Broker;

@interface WalletTableViewController : UITableViewController

-(id) initWithModel:(Wallet *) model broker:(Broker *) broker;

@end
