//
//  DetailViewController.m
//  Homepwner
//
//  Created by Keith Merrill on 8/2/13.
//  Copyright (c) 2013 Keith Merrill. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"

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

@end
