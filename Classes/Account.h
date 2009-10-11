#import <Foundation/Foundation.h>

@interface Account : NSObject {
	NSString *username;
	NSString *password;
	BOOL selected;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic) BOOL selected;

@end
