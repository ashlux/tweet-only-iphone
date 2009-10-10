#import "MGTwitterEngine.h"
#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<MGTwitterEngineDelegate> {
    MGTwitterEngine *twitterEngine;
	
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UITextView *tweetTextView;
	IBOutlet UIButton *submitTweetButton;
	
	IBOutlet UILabel *tweetSizeLabel;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextView *tweetTextView;
@property (nonatomic, retain) IBOutlet UILabel *tweetSizeLabel;
@property (nonatomic, retain) IBOutlet UIButton *submitTweetButton;

-(IBAction) submitTweet;

@end
