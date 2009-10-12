#import "AccountManager.h"
#import "KeychainUtils.h"

@implementation AccountManager

static NSString *selectedUsernameKey = @"selectedUsernameKey";

static NSString *usernamesKey = @"usernamesKey";

static NSString *keychainServiceName = @"password";

- (NSString*)getSelectedUsername {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:selectedUsernameKey];
}

- (BOOL)isSelectedUsername:(NSString*)username {
	return ([username isEqualToString:[self getSelectedUsername]]); 
}

- (void)setSelectedUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:selectedUsernameKey];
}

- (NSString*)getPasswordForUsername:(NSString*)username {
	if (username == nil) return nil;
	
	NSError *error = [[NSError alloc] init];
	NSString *password = [KeychainUtils getPasswordForUsername:username andServiceName:keychainServiceName error:&error];
	[error release];
	return password;
}

- (void)addPasswordToKeychain:(NSString*)password forUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:selectedUsernameKey];
	
	NSError *error = [[NSError alloc] init];
	[KeychainUtils storeUsername:username andPassword:password forServiceName:@"password" updateExisting:TRUE error:&error];
	[error release];
}

- (NSMutableArray*)getAccountUsernames {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:usernamesKey];
	NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	return [arr mutableCopy];
}

- (Account*)getSelectedAccount {
	Account *account = [[Account alloc] init];
	account.username = [self getSelectedUsername];
	account.password = [self getPasswordForUsername:account.username];
	account.selected = YES;
	return [account autorelease];
}

- (NSMutableArray*)getAccounts {
	NSArray *usernames = [self getAccountUsernames];
	
	NSMutableArray *accounts = [[NSMutableArray alloc] init];
	for (NSObject *username in usernames) {
		Account *account = [[Account alloc] init];
		account.username = (NSString*) username;	
		account.selected = [self isSelectedUsername:(NSString*) username];
		account.password = [self getPasswordForUsername:(NSString*) username];
		[accounts addObject:account];
	}
	
	return [accounts autorelease];
}

- (void)addAccountWithUsername:(NSString*)username withPassword:(NSString*)password {
	Account *account = [[Account alloc] init];
	account.username = username;
	account.password = password;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *usernames = [self getAccountUsernames];
	if (usernames == nil) {
		usernames = [[NSMutableArray alloc] init];
	}

	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[usernames arrayByAddingObject:username]] 
				 forKey:usernamesKey];
	[self addPasswordToKeychain:password forUsername:username];
}

@end
