#import <UIKit/UIKit.h>

@interface AccountEditViewController : UIViewController {
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

- (IBAction)saveAccount;
- (IBAction)cancelEdit;
- (IBAction)deleteAccount;

@end
