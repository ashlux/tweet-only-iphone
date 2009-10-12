#import "MGTwitterEngine.h"
#import "AccountManager.h"
#import <UIKit/UIKit.h>

@interface PostTweetViewController : UIViewController<MGTwitterEngineDelegate> {
    AccountManager *accountManager;
	MGTwitterEngine *twitterEngine;
	
	IBOutlet UILabel *usernameLabel;
	IBOutlet UITextView *tweetTextView;
	IBOutlet UIButton *submitTweetButton;
	
	IBOutlet UILabel *tweetSizeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UITextView *tweetTextView;
@property (nonatomic, retain) IBOutlet UILabel *tweetSizeLabel;
@property (nonatomic, retain) IBOutlet UIButton *submitTweetButton;

-(IBAction) submitTweet;

@end
