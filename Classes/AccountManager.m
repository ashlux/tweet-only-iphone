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
	
	NSError *error;
	NSString *password = [KeychainUtils getPasswordForUsername:username andServiceName:keychainServiceName error:&error];
	return password;
}

- (void)addPasswordToKeychain:(NSString*)password forUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:selectedUsernameKey];
	
	NSError *error;
	[KeychainUtils storeUsername:username andPassword:password forServiceName:@"password" updateExisting:TRUE error:&error];
}

- (NSMutableArray*)getAccountUsernames {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [defaults objectForKey:usernamesKey];
	if (data == nil) {
		return [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	}
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

- (void)saveAccountWithUsername:(NSString*)username withPassword:(NSString*)password {
	Account *account = [[Account alloc] init];
	account.username = username;
	account.password = password;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *usernames = [self getAccountUsernames];

	// if username already exists, remove it
	[usernames removeObject:username];
	[usernames addObject:username];
	
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:usernames]] 
				 forKey:usernamesKey];
	[self addPasswordToKeychain:password forUsername:username];
}

- (Account*)getAccountForUsername:(NSString*)username {
	if (![[self getAccountUsernames] containsObject:username]) {
		return nil;
	}
	
	Account *account = [[Account alloc] init];
	[account setUsername:username];
	[account setPassword:[self getPasswordForUsername:username]];
	[account setSelected:[self isSelectedUsername:username]];
	return [account autorelease];
}

- (void)removeAccountForUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *usernames = [self getAccountUsernames];
	[usernames removeObject:username];
	
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:usernames]] 
				 forKey:usernamesKey];

	NSError *error;
	[KeychainUtils deleteItemForUsername:username andServiceName:keychainServiceName error:&error];
}

@end
