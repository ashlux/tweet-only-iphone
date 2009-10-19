#import "MGTwitterEngine.h"
#import "AccountManager.h"
#import <UIKit/UIKit.h>
#import "PictureChooserDelegate.h"

@interface PostTweetViewController : UIViewController<MGTwitterEngineDelegate, PictureChooserDelegate> {
    AccountManager *accountManager;
	MGTwitterEngine *twitterEngine;
	
	IBOutlet UILabel *usernameLabel;
	IBOutlet UITextView *tweetTextView;
	IBOutlet UIBarButtonItem *submitTweetButton;
	IBOutlet UIButton *clearButton;
	
	IBOutlet UILabel *tweetSizeLabel;
	
	IBOutlet UIImageView *eagle;
}

@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UITextView *tweetTextView;
@property (nonatomic, retain) IBOutlet UILabel *tweetSizeLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitTweetButton;
@property (nonatomic, retain) IBOutlet UIButton *clearButton;
@property (nonatomic, retain) IBOutlet UIImageView *eagle; 

-(IBAction) submitTweet;
-(IBAction) clearTweet;
-(IBAction) addPhoto;

@end
