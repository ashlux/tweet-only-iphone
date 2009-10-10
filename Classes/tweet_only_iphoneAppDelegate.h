
#import <UIKit/UIKit.h>

@interface tweet_only_iphoneAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end
