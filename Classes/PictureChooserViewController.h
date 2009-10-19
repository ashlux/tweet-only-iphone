#import <UIKit/UIKit.h>
#import "PictureChooserDelegate.h"

@interface PictureChooserViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	BOOL pictureSelected;

    __weak NSObject <PictureChooserDelegate> *_delegate;
}

- (IBAction) cancelAddingPhoto;
- (IBAction) addExistingPhoto;
- (IBAction) takeNewPhotoWithCamera;

-(void) setDelegate:(NSObject*)delegate;

@end
