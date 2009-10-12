#import "AccountEditViewController.h"
#import "AccountManager.h"

@implementation AccountEditViewController

@synthesize usernameTextField;
@synthesize passwordTextField;

- (IBAction)saveAccount {
	AccountManager *accountManager = [[AccountManager alloc] init];
	[accountManager addAccountWithUsername:usernameTextField.text withPassword:passwordTextField.text];
	[accountManager release];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelEdit {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deleteAccount {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[usernameTextField release];
	[passwordTextField release];

    [super dealloc];
}


@end
