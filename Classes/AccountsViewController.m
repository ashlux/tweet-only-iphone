#import "AccountsViewController.h"
#import "AccountManager.h"
#import "AccountEditViewController.h"

@implementation AccountsViewController

@synthesize accountTableView;

static AccountManager *accountManager;

- (void)viewDidLoad {
    [super viewDidLoad];	
	accountManager = [[AccountManager alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Number of accounts=%d.", [[accountManager getAccounts] count]);
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
	cell.selected = account.selected;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (IBAction)addAccount {
	AccountEditViewController *aView = [[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:aView animated:YES];
	[accountTableView reloadData];
	[aView release];
}

- (void)dealloc {
	[accountManager release];
	[accountTableView release];

	[super dealloc];
}

@end
