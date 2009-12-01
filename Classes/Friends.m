#import "Friends.h"

@implementation Friends

- (id)initWithMGTwitterEngineDelegate:(NSObject<MGTwitterEngineDelegate>*)twitterEngineDelegate {
	if (self) {
		_delegate = twitterEngineDelegate;
	}
	return self;
}

- (void)getFriendsForUsername:(NSString*)username withPassword:(NSString*)password {
	if (!twitterEngine) {
		twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:_delegate];
	}
	[twitterEngine setUsername:username password:password];
	[twitterEngine getRecentlyUpdatedFriendsFor:username  startingAtPage:0];
}

- (void)dealloc {
	[twitterEngine closeAllConnections];
	[twitterEngine release];
	
    [super dealloc];
}


@end
