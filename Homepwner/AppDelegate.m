//
//  AppDelegate.m
//  Homepwner
//
//  Created by Dane on 8/19/15.
//  Copyright (c) 2015 Regnier Design. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"

@interface AppDelegate ()

@end

NSString * const BNRNextItemValuePrefsKey = @"NextItemValue";
NSString * const BNRNextItemNamePrefsKey = @"NextItemName";


@implementation AppDelegate

#pragma mark Setting up User Preferences

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{BNRNextItemValuePrefsKey : @75, BNRNextItemNamePrefsKey : @"Coffee Cup"};
    [defaults registerDefaults:factorySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Move this into an if statement for if state restoration didn't work
    if (!self.window.rootViewController) {

    // Creating BNRItemsViewController
    BNRItemsViewController *itemsViewController = [[BNRItemsViewController alloc] init];
    
    // Setting up navigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    
    // Placing in view hierarchy
//    self.window.rootViewController = itemsViewController;
    
    // Setting up restoration identifier for navController
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    // Putting the nav view in the hierarchy
    self.window.rootViewController = navController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

#pragma mark State Restoration
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // Last object in path array is restorationIdentifier for this VC
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only one component, this is the RVC
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    
    return vc;
}
@end

















