//
//  tweet_offline_iphoneAppDelegate.m
//  tweet-offline-iphone
//
//  Created by Ash Lux on 10/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "tweet_offline_iphoneAppDelegate.h"


@implementation tweet_offline_iphoneAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

