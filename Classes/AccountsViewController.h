#import <UIKit/UIKit.h>

@interface AccountsViewController : UITableViewController {
	IBOutlet UITableView *accountTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *accountTableView;


- (IBAction)addAccount;

@end
