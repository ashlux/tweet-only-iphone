#import "FriendsViewController.h"
#import "MGTwitterEngine.h"
#import "NetworkActivity.h"
#import "AccountManager.h"

@implementation FriendsViewController

@synthesize friendsTable;

+(id)createInstance {
	FriendsViewController *aView = [[FriendsViewController alloc] initWithNibName:@"FriendsListViewController" 
																				   bundle:[NSBundle mainBundle]];
	return [aView autorelease];
}

- (void) setDelegate:(NSObject *)delegate {
	_delegate = delegate;
}

- (void)getFriendsForUsername:(NSString*)username withPassword:(NSString*)password {
	MGTwitterEngine *twitterEngine = [[[MGTwitterEngine alloc] initWithDelegate:self] autorelease];
	[twitterEngine setUsername:username password:password];
	[NetworkActivity start];
	[twitterEngine getRecentlyUpdatedFriendsFor:username  startingAtPage:0];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	AccountManager *accountManager = [[AccountManager alloc] init];
	Account *account = [accountManager getSelectedAccount];
	[accountManager release];
	[self getFriendsForUsername:account.username withPassword:account.password];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [userInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *friend = [userInfo objectAtIndex:indexPath.row];
//	NSLog(@"%@", friend);
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:[friend objectForKey:@"screen_name"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_delegate friendSelected:[[userInfo objectAtIndex:indexPath.row] objectForKey:@"screen_name"]];
	[self dismissModalViewControllerAnimated:YES];	
}

- (IBAction)cancel {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
	[NetworkActivity stop];
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	[NetworkActivity stop];
	
	NSLog(@"Twitter request failed! (%@) Error: %@ (%@)", 
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sad panda..." 
													message:@"Could not get list of friends." 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release]; 
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
}

- (void)userInfoReceived:(NSArray *)userInfop forRequest:(NSString *)identifier
{
	[NetworkActivity stop];

	userInfo = [userInfop retain];
	[friendsTable reloadData];
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	[NetworkActivity stop];
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier 
{
	[NetworkActivity stop];
}

- (void)dealloc {
	[friendsTable release];
	[userInfo release];
	_delegate = nil;
	
    [super dealloc];
}


@end
