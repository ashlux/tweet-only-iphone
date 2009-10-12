#import "AccountsViewController.h"
#import "AccountManager.h"
#import "AccountEditViewController.h"

@implementation AccountsViewController

@synthesize accountTableView;

AccountManager *accountManager;

- (void)viewDidLoad {
    [super viewDidLoad];	
	accountManager = [[AccountManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[accountTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[accountManager getAccounts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Account *account = [[accountManager getAccounts] objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:account.username];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;\
	if (account.selected) {
		[cell.imageView setImage:[UIImage imageNamed:@"black-checkmark.png"]];
		[accountTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	} else {
		[cell.imageView setImage:[UIImage imageNamed:@"empty-checkmark-area.png"]];
	}
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[tableView cellForRowAtIndexPath:indexPath].imageView setImage:[UIImage imageNamed:@"empty-checkmark-area.png"]];
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[tableView cellForRowAtIndexPath:indexPath].imageView setImage:[UIImage imageNamed:@"black-checkmark.png"]]; 
	[tableView cellForRowAtIndexPath:indexPath].selected = NO;
	
	[accountManager setSelectedUsername:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

- (IBAction)addAccount {
	AccountEditViewController *aView = [AccountEditViewController createInstance];
	[self presentModalViewController:aView animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	Account *account = [accountManager getAccountForUsername:cell.textLabel.text];
	
	AccountEditViewController *aView = [AccountEditViewController createInstance];			
	[self presentModalViewController:aView animated:YES];
	[aView setAccount:account];
}

- (void)dealloc {
	[accountManager release];
	[accountTableView release];

	[super dealloc];
}

@end
