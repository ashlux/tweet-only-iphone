#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountManager : NSObject {
}

- (Account*)getSelectedAccount;
- (void)setSelectedAccountWithUsername:(NSString*)username withPassword:(NSString*)password;

@end
