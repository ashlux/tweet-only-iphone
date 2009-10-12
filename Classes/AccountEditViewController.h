#import <UIKit/UIKit.h>
#import "Account.h"

@interface AccountEditViewController : UIViewController {
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	
	NSString *usernameBefore;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

- (IBAction)saveAccount;
- (IBAction)cancelEdit;
- (IBAction)deleteAccount;

- (void)setAccount:(Account*)account;

+(id)createInstance;

@end
