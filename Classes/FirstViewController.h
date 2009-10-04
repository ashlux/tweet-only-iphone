#import "MGTwitterEngine.h"
#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<MGTwitterEngineDelegate> {
    MGTwitterEngine *twitterEngine;
}

@end
