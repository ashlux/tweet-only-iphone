#import <UIKit/UIKit.h>
#import "MGTwitterEngine.h"

@interface Friends : NSObject {
	MGTwitterEngine *twitterEngine;
	
	NSObject<MGTwitterEngineDelegate> *_delegate;
}

- (id)initWithMGTwitterEngineDelegate:(NSObject<MGTwitterEngineDelegate>*)twitterEngineDelegate;

- (void)getFriendsForUsername:(NSString*)username withPassword:(NSString*)password;

@end
