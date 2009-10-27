#import <UIKit/UIKit.h>
#import "FriendChoosenDelegate.h"

@interface FriendsViewController : UIViewController {
	IBOutlet UITableView *friendsTable;
	
	NSArray *userInfo;
	
	__weak NSObject <FriendChoosenDelegate> *_delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *friendsTable;

- (IBAction)cancel;
-(void) setDelegate:(NSObject*)delegate;

+ (id)createInstance;

@end
