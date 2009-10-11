#import "AccountManager.h"
#import "KeychainUtils.h"

@implementation AccountManager

static NSString *selectedUsernameKey = @"selectedUsernameKey";

static NSString *keychainServiceName = @"password";

- (NSString*)getSelectedUsername {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:selectedUsernameKey];
}

- (void)setSelectedUsername:(NSString*)username; {
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

- (void)setPassword:(NSString*)password forUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:selectedUsernameKey];
	
	NSError *error = [[NSError alloc] init];
	[KeychainUtils storeUsername:username andPassword:password forServiceName:@"password" updateExisting:TRUE error:&error];
	[error release];
}

- (Account*)getSelectedAccount {
	Account *account = [[Account alloc] init];
	account.username = [self getSelectedUsername];
	account.password = [self getPasswordForUsername:account.username];
	account.selected = YES;
	return [account autorelease];
}

- (void)setSelectedAccountWithUsername:(NSString*)username withPassword:(NSString*)password {
	[self setSelectedUsername:username];
	[self setPassword:password forUsername:username];
}

@end
