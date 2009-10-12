
#import "tweet_only_iphoneAppDelegate.h"
#import "PostTweetViewController.h"
#import "AccountManager.h"
#import "AccountEditViewController.h"

@implementation PostTweetViewController

@synthesize usernameLabel;
@synthesize tweetTextView;
@synthesize tweetSizeLabel;
@synthesize submitTweetButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	accountManager = [[AccountManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// get the selected account because it might have changed
	[usernameLabel setText:[NSString stringWithFormat:@"Tweeting with %@", [accountManager getSelectedAccount].username]];
	
	// If no accounts present, prompt to create one
	if ([[accountManager getAccounts] count] == 0) {
		AccountEditViewController *aView = [AccountEditViewController createInstance];
		[self presentModalViewController:aView animated:YES];
	}
}

// TODO: Move to NetworkActivy class	
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
	if ([[tweetTextView text] length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send tweet" 
														message:@"Cannot not send empty tweets." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
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
	[tweetTextView resignFirstResponder];
	Account *account = [accountManager getSelectedAccount];
	[twitterEngine setUsername:account.username password:account.password];
	[twitterEngine sendUpdate:[tweetTextView text]];
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
	[self turnOffNetworkActivityIndicator];
	[self enableSubmitTweetButton];
	[tweetTextView setText:@""];
	[tweetSizeLabel setText:@"0/140"];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:@"Successfully posted status update!" 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
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
	[twitterEngine closeAllConnections];
    [twitterEngine release];
	
	[AccountManager release];
	
	[usernameLabel release];
	[tweetTextView release];
	[tweetSizeLabel release];
	[submitTweetButton release];
	
	[super dealloc];
}

@end
