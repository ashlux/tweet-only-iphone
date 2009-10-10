#import <Foundation/Foundation.h>

@interface AccountManager : NSObject {
}

+(NSString*) getSelectedUsername;
+(NSMutableArray*) getAllUsernames;
+(NSString*) getPasswordForUsername:(NSString*)username;
+(void) setPassword:(NSString*)password forUsername:(NSString*)username;

@end
