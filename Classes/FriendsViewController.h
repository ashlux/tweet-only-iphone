#import <UIKit/UIKit.h>
#import "FriendChoosenDelegate.h"
#import "MGTwitterEngine.h"

@interface FriendsViewController : UIViewController {
	__weak NSObject <FriendChoosenDelegate> *_delegate;

	IBOutlet UITableView *friendsTable;
	MGTwitterEngine *twitterEngine;
	
	NSArray *userInfo;	
}

@property (nonatomic, retain) IBOutlet UITableView *friendsTable;

-(IBAction)cancel;
-(void) setDelegate:(NSObject*)delegate;

+ (id)createInstance;

@end
