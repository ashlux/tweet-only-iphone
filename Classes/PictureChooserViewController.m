#import "PictureChooserViewController.h"

@implementation PictureChooserViewController

-(void) popMe {
	[self dismissModalViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (pictureSelected) {
		// See: http://stackoverflow.com/questions/1298893/calling-poptorootviewcontrolleranimated-after-uiimagepicker-finish-or-cancel-ip
		[self performSelector:@selector(popMe) withObject:nil afterDelay:0.1];   
	}
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
	
	UIImagePickerController *myPicker = [[UIImagePickerController alloc] init];
	myPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:NO];	
	[myPicker release];
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
	
	UIImagePickerController *myPicker = [[UIImagePickerController alloc] init];
	myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	myPicker.delegate = self;
	[self presentModalViewController:myPicker animated:NO];
	[myPicker release];
}

- (IBAction) cancelAddingPhoto {
	[self dismissModalViewControllerAnimated:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	pictureSelected = YES;

	[picker dismissModalViewControllerAnimated:YES];
	
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	CGImageRef cgImage = [image CGImage];
	UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
	[_delegate pictureSelected:[copyOfImage autorelease]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)img
				  editingInfo:(NSDictionary *)editingInfo {
	pictureSelected = YES;

	[picker dismissModalViewControllerAnimated:YES];
		
	CGImageRef cgImage = [img CGImage];
	UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
	[_delegate pictureSelected:[copyOfImage autorelease]];
}	

- (void)dealloc {
	_delegate = nil;

    [super dealloc];
}


@end
