#import <UIKit/UIKit.h>
#import "Account.h"

@interface AccountEditViewController : UIViewController {
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIButton *deleteButton;
	IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UINavigationBar *navBar;
	
	NSString *usernameBefore;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

- (IBAction)saveAccount;
- (IBAction)cancelEdit;
- (IBAction)deleteAccount;

- (void)setAccount:(Account*)account;
- (void)hideCancelButton;

+(id)createInstance;

@end
