//   
//  AppDelegate.m
//   
//  Created by alpha yu on 2024/1/24
//   
   

#import "AppDelegate.h"
#import "AppManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AppManager.shared didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

@end
