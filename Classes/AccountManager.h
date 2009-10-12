#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountManager : NSObject {
}

- (Account*)getSelectedAccount;
- (NSMutableArray*)getAccounts;
- (void)saveAccountWithUsername:(NSString*)username withPassword:(NSString*)password;
- (void)setSelectedUsername:(NSString*)username;
- (Account*)getAccountForUsername:(NSString*)username;
- (void)removeAccountForUsername:(NSString*)username;

@end
