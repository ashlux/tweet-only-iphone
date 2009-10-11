#import "Account.h"

@implementation Account

@synthesize username;
@synthesize password;
@synthesize selected;

-(void) dealloc {
	[super dealloc];
	
	[username release];
	[password release];
}

@end
