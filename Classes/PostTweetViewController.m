#import "PostTweetViewController.h"
#import "AccountManager.h"
#import "AccountEditViewController.h"
#import "PictureChooserViewController.h"w
#import "Twitpic.h"
#import "NetworkActivity.h"

@implementation PostTweetViewController

@synthesize usernameLabel;
@synthesize tweetTextView;
@synthesize tweetSizeLabel;
@synthesize submitTweetButton;
@synthesize clearButton;
@synthesize addPhotoButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	accountManager = [[AccountManager alloc] init];
}

- (void)pictureSelected:(UIImage*)image {
	Twitpic *twitpic = [[Twitpic alloc] init];
	[NetworkActivity start];
	NSString *twitpicUrl = [twitpic uploadPicture:image withAccount:[accountManager getSelectedAccount]];
	[NetworkActivity stop];
	[tweetTextView setText:[NSString stringWithFormat:@"%@ %@", tweetTextView.text, twitpicUrl]];
	[twitpic release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// get the selected account because it might have changed
	[usernameLabel setText:[NSString stringWithFormat:@"Tweeting with %@", [accountManager getSelectedAccount].username]];
	
	// If no accounts present, prompt to create one
	if ([[accountManager getAccounts] count] == 0) {
		AccountEditViewController *aView = [AccountEditViewController createInstance];
		[self presentModalViewController:aView animated:YES];
		[aView hideCancelButton];
	}
}

-(IBAction) addFriend {
	// show friend dialog
}

- (IBAction)addPhoto {
	PictureChooserViewController *aView = [[[PictureChooserViewController alloc] initWithNibName:@"PictureChooserViewController" 
																						 bundle:[NSBundle mainBundle]] autorelease];
	[aView setDelegate:self];
	[self presentModalViewController:aView animated:YES];
}

- (void)enableSubmitTweetButton
{
	submitTweetButton.enabled=YES;
	clearButton.enabled=YES;
}

- (void)disableSubmitTweetButton
{
	submitTweetButton.enabled=NO;
	clearButton.enabled=NO;
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
	
	[NetworkActivity start];
	[self disableSubmitTweetButton];
	[tweetTextView resignFirstResponder];
	Account *account = [accountManager getSelectedAccount];
	[twitterEngine setUsername:account.username password:account.password];
	[twitterEngine sendUpdate:[tweetTextView text]];
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
	[NetworkActivity stop];
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
	[NetworkActivity stop];
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
	[NetworkActivity stop];
	[self enableSubmitTweetButton];
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
	[self enableSubmitTweetButton];
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
	[self enableSubmitTweetButton];
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
	[self enableSubmitTweetButton];
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier 
{
	[NetworkActivity stop];
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


-(IBAction) clearTweet {
	[tweetTextView setText:@""];
}

- (void)dealloc {	
	[twitterEngine closeAllConnections];
    [twitterEngine release];
	
	[AccountManager release];
	
	[usernameLabel release];
	[tweetTextView release];
	[tweetSizeLabel release];
	[submitTweetButton release];
	[clearButton release];
	[addPhotoButton release];
	
	[super dealloc];
}

@end
