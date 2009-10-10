
#import "tweet_only_iphoneAppDelegate.h"
#import "KeychainUtils.h"
#import "FirstViewController.h"

@implementation FirstViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize tweetTextView;
@synthesize tweetSizeLabel;
@synthesize submitTweetButton;

- (void)retrieveStoredUsernamePassword {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username  = [defaults objectForKey:@"username"];
	
	// no username has been saved, so don't do anything
	if (username == nil) {
		return;
	}
	
	NSError *error = [[NSError alloc] init];
	NSString *password = [KeychainUtils getPasswordForUsername:username andServiceName:@"password" error:&error];

	usernameTextField.text = username;
	passwordTextField.text = password;
}

- (void)storeUsername:(NSString*)username withPassword:(NSString*)password {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:@"username"];
	NSError *error = [[NSError alloc] init];
	[KeychainUtils storeUsername:username andPassword:password forServiceName:@"password" updateExisting:TRUE error:&error];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	
	[self retrieveStoredUsernamePassword];
}

- (void)turnOnNetworkActivityIndicator
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:TRUE];	
}

- (void)turnOffNetworkActivityIndicator
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:FALSE];	
}

- (void)enableSubmitTweetButton
{
	submitTweetButton.enabled=YES;
}

- (void)disableSubmitTweetButton
{
	submitTweetButton.enabled=NO;
}

-(IBAction) submitTweet
{
	if ([[tweetTextView text] length] > 140) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send tweet" 
														message:@"Cannot not send tweet because it is over 140 characters." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self turnOnNetworkActivityIndicator];
	[self disableSubmitTweetButton];
	[twitterEngine setUsername:[usernameTextField text] password:[passwordTextField text]];
	[twitterEngine sendUpdate:[tweetTextView text]];
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];

	NSLog(@"Twitter request failed! (%@) Error: %@ (%@)", 
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sad panda..." 
													message:@"Could not post tweet status update." 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release]; 
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
	[self storeUsername:usernameTextField.text withPassword:passwordTextField.text];
	
	[tweetTextView setText:@""];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:@"Successfully posted status update!" 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier 
{
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	int tweetSize = [[textView text] length];
	[tweetSizeLabel setText:[NSString stringWithFormat:@"%d/140", tweetSize]];
	
	if (tweetSize > 140) {
		tweetSizeLabel.textColor = [UIColor redColor];
	} else {
		tweetSizeLabel.textColor = [UIColor blackColor];
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	// Hack to resign keyboard when "Done" is presseds
	if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;	
}

- (void)dealloc {
    [super dealloc];
	
	[twitterEngine closeAllConnections];
    [twitterEngine release];

	
	[usernameTextField release];
	[passwordTextField release];
	[tweetTextView release];
	[tweetSizeLabel release];
	[submitTweetButton release];
}

@end
