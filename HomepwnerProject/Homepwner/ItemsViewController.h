//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Keith Merrill on 7/2/13.
//  Copyright (c) 2013 Keith Merrill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController<UITableViewDataSource>
{
    IBOutlet UIView *headerView;
}

- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;

@end
