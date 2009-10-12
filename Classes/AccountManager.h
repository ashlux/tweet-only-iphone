#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountManager : NSObject {
}

- (Account*)getSelectedAccount;
- (NSMutableArray*)getAccounts;
- (void)addAccountWithUsername:(NSString*)username withPassword:(NSString*)password;
- (void)setSelectedUsername:(NSString*)username;

@end
