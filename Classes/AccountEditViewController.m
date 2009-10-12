#import "AccountEditViewController.h"
#import "AccountManager.h"
#import "Account.h"

@implementation AccountEditViewController

@synthesize usernameTextField;
@synthesize passwordTextField;

+(id)createInstance {
	return [[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:[NSBundle mainBundle]];
}

- (void)setAccount:(Account*)account {
	[self.usernameTextField setText:account.username];
	[self.passwordTextField setText:account.password];
	usernameBefore = account.username;
}

- (IBAction)saveAccount {
	AccountManager *accountManager = [[AccountManager alloc] init];
	[accountManager removeAccountForUsername:usernameBefore];
	[accountManager saveAccountWithUsername:usernameTextField.text withPassword:passwordTextField.text];
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
