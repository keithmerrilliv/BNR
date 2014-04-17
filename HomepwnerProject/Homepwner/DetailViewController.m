//
//  DetailViewController.m
//  Homepwner
//
//  Created by Keith Merrill on 8/2/13.
//  Copyright (c) 2013 Keith Merrill. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor  groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[self.item itemName]];
    [serialNumberField setText:[self.item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [self.item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[self.item dateCreated]]];
    
    NSString *imageKey = [_item imageKey];
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [self.item setItemName:[nameField text]];
    [self.item setSerialNumber:[serialNumberField text]];
    [self.item setValueInDollars:[[valueField text] intValue]];
}

- (void)setItem:(BNRItem *)i
{
    _item = i;
    [[self navigationItem] setTitle:[self.item itemName]];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise we just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)backGroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [_item imageKey];
    
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string from a unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [_item setImageKey:key];
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:[_item imageKey]];

    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    // Take image picker off the screen
    // You must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
