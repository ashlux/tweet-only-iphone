#import <UIKit/UIKit.h>

@interface PictureChooserViewController : UIViewController<UIImagePickerControllerDelegate> {
	UIImagePickerController *picker;
	NSDictionary *info;
}

- (IBAction) cancelAddingPhoto;
- (IBAction) addExistingPhoto;
- (IBAction) takeNewPhotoWithCamera;

- (BOOL) imageWasSelected;
- (UIImage*) getSelectedImage;

@end
