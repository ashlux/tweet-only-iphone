#import "NetworkActivity.h"
#import "tweet_only_iphoneAppDelegate.h"

@implementation NetworkActivity

+ (void)start
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];	
}

+ (void)stop
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];	
}

@end
