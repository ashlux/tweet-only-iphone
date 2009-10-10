#import "AccountManager.h"
#import "KeychainUtils.h"

@implementation AccountManager

static NSString *selectedUsernameKey = @"username";

//static NSString *usernamesKey = @"accounts";

static NSString *keychainServiceName = @"password";

+(NSString*) getSelectedUsername {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:selectedUsernameKey];
}

//+(NSMutableArray*) getAllUsernames {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	return [defaults objectForKey:usernamesKey];
//}

+(NSString*) getPasswordForUsername:(NSString*)username {
	NSError *error = [[NSError alloc] init];
	NSString *password = [KeychainUtils getPasswordForUsername:username andServiceName:keychainServiceName error:&error];
	[error release];
	return password;
}

+(void) setPassword:(NSString*)password forUsername:(NSString*)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:selectedUsernameKey];

	NSError *error = [[NSError alloc] init];
	[KeychainUtils storeUsername:username andPassword:password forServiceName:@"password" updateExisting:TRUE error:&error];
	[error release];
}

@end
