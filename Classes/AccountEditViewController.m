#import "AccountEditViewController.h"
#import "AccountManager.h"
#import "Account.h"

@implementation AccountEditViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize deleteButton; 
@synthesize cancelButton;
@synthesize navBar;

+(id)createInstance {
	AccountEditViewController *aView = [[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" 
																				   bundle:[NSBundle mainBundle]];
	return [aView autorelease];
}

- (void)hideCancelButton {
	NSMutableArray *items = [[navBar.items mutableCopy] autorelease];
	[items removeObject: cancelButton];
	navBar.items = items;
}

- (void)setAccount:(Account*)account {
	[self.usernameTextField setText:account.username];
	[self.passwordTextField setText:account.password];
	usernameBefore = account.username;
	
	[deleteButton setHidden:FALSE];
}

- (IBAction)saveAccount {
	if (usernameTextField.text.length == 0 ||
		passwordTextField.text.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Cannot save account. Both username and password are required." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
 	
	AccountManager *accountManager = [[AccountManager alloc] init];
	[accountManager removeAccountForUsername:usernameBefore];
	[accountManager saveAccountWithUsername:usernameTextField.text withPassword:passwordTextField.text];
	[accountManager release];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelEdit {
	AccountManager *accountManager = [[AccountManager alloc] init];
	int numOfAccounts = [[accountManager getAccounts] count];
	[accountManager release];
	
	if (numOfAccounts == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Cannot exit account setup. You must have at least one account to use Tweet Only." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deleteAccount {
	AccountManager *accountManager = [[AccountManager alloc] init];
	[accountManager removeAccountForUsername:usernameBefore];
	[accountManager release];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[usernameTextField release];
	[passwordTextField release];
	[deleteButton release];
	[cancelButton release];
	[navBar release];
	
    [super dealloc];
}


@end
