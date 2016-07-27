//
//  AppDelegate.m
//  MyWallet
//
//  Created by Alejandro on 18/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "AppDelegate.h"
#import "Wallet.h"
#import "Broker.h"
#import "WalletTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // crear el modelo
    Wallet *wallet = [[Wallet alloc] initWithAmount:1 currency:@"USD"];
    [wallet plus:[Money euroWithAmount:1]];
    [wallet plus:[[Money alloc] initWithAmount:5 currency:@"JPY"]];
    [wallet plus:[Money euroWithAmount:10]];
    
    // tasas de conversión
    Broker *broker = [Broker new];
    [broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];
    [broker addRate:4 fromCurrency:@"EUR" toCurrency:@"JPY"];
    [broker addRate:2 fromCurrency:@"USD" toCurrency:@"JPY"];
    
    // crear el view controller
    UIViewController *VC = [[WalletTableViewController alloc] initWithModel:wallet broker:broker];
    
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
