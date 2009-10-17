#import "PictureChooserViewController.h"

@implementation PictureChooserViewController

- (UIImagePickerController*) getPicker {
	if (picker == nil) {
		picker = [[UIImagePickerController alloc] init];
	}
	return picker;
}

- (UIImage*) getSelectedImage {
	return (UIImage*) [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

- (BOOL) imageWasSelected {
	if ([self getSelectedImage] == nil) return NO;
	else return YES;
}

- (IBAction) addExistingPhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"Camera is not an available source." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	UIImagePickerController *myPicker = [self getPicker];
	myPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:YES];	
}

- (IBAction) takeNewPhotoWithCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"Camera is not an available source." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	UIImagePickerController *myPicker = [self getPicker];
	myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:YES];
}

- (IBAction) cancelAddingPhoto {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)myPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[myPicker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)myPicker {
	[myPicker dismissModalViewControllerAnimated:YES];
	[self cancelAddingPhoto];
}

- (void)dealloc {
    [super dealloc];
	
	[picker release];
}


@end
