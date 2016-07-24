//
//  SimpleViewController.h
//  MyWallet
//
//  Created by Alejandro on 23/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

- (IBAction)displayText:(id)sender;

@end
