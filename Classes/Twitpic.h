#import <Foundation/Foundation.h>
#import "Account.h"

@interface Twitpic : NSObject {
}

- (NSString*)uploadPicture:UIImage withAccount:(Account*)account;

@end
