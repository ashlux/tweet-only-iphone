#import "PictureChooserViewController.h"

@implementation PictureChooserViewController

- (UIImagePickerController*) pickerController {
	if (!pickerController) {
		pickerController = [[UIImagePickerController alloc] init];
	}
	return pickerController;
}

- (void) setDelegate:(NSObject *)delegate {
	_delegate = delegate;
}

// TODO: duplication
- (IBAction) addExistingPhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"Photo album is not an available source on your device." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	UIImagePickerController *myPicker = [self pickerController];
	myPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:YES];	
}


// TODO: duplication
- (IBAction) takeNewPhotoWithCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:@"Camera is not an available source on your device." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	UIImagePickerController *myPicker = [self pickerController];
	myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:YES];
}

- (IBAction) cancelAddingPhoto {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	pictureSelected = YES;
	
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	CGImageRef cgImage = [image CGImage];
	UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
	[_delegate pictureChosen:[copyOfImage autorelease]];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)myPicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)img
				  editingInfo:(NSDictionary *)editingInfo {
	pictureSelected = YES;
	
	CGImageRef cgImage = [img CGImage];
	UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
	[_delegate pictureChosen:[copyOfImage autorelease]];
	
	[self dismissModalViewControllerAnimated:YES];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}	

- (void)dealloc {
	_delegate = nil;
	[pickerController release];
    [super dealloc];
}


@end
