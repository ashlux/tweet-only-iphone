
#import "tweet_only_iphoneAppDelegate.h"
#import "FirstViewController.h"

@implementation FirstViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize tweetTextView;
@synthesize tweetSizeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
}

- (void)turnOnNetworkActivityIndicator
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:TRUE];	
}

- (void)turnOffNetworkActivityIndicator
{
	[(tweet_only_iphoneAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:FALSE];	
}

-(IBAction) submitTweet
{
	[self turnOnNetworkActivityIndicator];
	[twitterEngine setUsername:[usernameTextField text] password:[passwordTextField text]];
	[twitterEngine sendUpdate:[tweetTextView text]];
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	[self turnOffNetworkActivityIndicator];
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
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	[self turnOffNetworkActivityIndicator];
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier 
{
	[self turnOffNetworkActivityIndicator];
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
}

@end
