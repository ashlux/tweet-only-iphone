#import "Twitpic.h"
#import "ASIFormDataRequest.h"

@implementation Twitpic

- (NSString*)getUrlFromResponseXml:(NSString*)responseXml {
	NSRange rangeBeginTag = [responseXml rangeOfString:@"<mediaurl>"];
	NSRange rangeEndTag = [responseXml rangeOfString:@"</mediaurl>"];
	
	return [responseXml substringWithRange:NSMakeRange(rangeBeginTag.location + 10, rangeEndTag.location - rangeBeginTag.location - 10)];
}

- (NSString*)uploadPicture:(UIImage*)image withAccount:(Account*)account {
	NSURL *url = [NSURL URLWithString:@"http://twitpic.com/api/upload"];
	NSData *twitpicImage = UIImagePNGRepresentation(image);
	
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
	
	[request setData:twitpicImage forKey:@"media"];
	[request setPostValue:account.username forKey:@"username"];
	[request setPostValue:account.password forKey:@"password"];
	
	[request start];
	
	return [self getUrlFromResponseXml:[request responseString]];
}

@end
