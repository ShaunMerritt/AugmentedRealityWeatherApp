//
//  SMAppDelegate.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/2/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMViewController.h"
#import "SMWelcomePageViewController.h"
#import "SMLocationModel.h"

@implementation SMAppDelegate {
    UIViewController *viewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstLaunch"]) {
        NSLog(@"Once");
        UIViewController *rootViewController = [[SMViewController alloc] init];
        viewController = [[UINavigationController alloc]
                          initWithRootViewController:rootViewController];
    } else {
        NSLog(@"First");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        SMLocationModel *selectedLocation = [[SMLocationModel alloc] initWithCityName:@"" latitude:0 longitude:0 degreesFromNorth:0];
//        NSArray *array = [[NSArray alloc] initWithObjects:selectedLocation, nil];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:@"savedLocationsArray"];
//        [[NSUserDefaults standardUserDefaults] synchronize];

        
        UIViewController *rootViewController = [[SMWelcomePageViewController alloc] init];
        viewController = [[UINavigationController alloc]
                          initWithRootViewController:rootViewController];
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
