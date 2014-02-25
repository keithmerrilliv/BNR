//
//  CMDViewController.h
//  cmEditDemo
//
//  Created by Keith Merrill IV on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <ShinobiEssentials/SEssentialsTabbedView.h>
#import <ShinobiEssentials/SEssentialsCarouselLinear2D.h>
#import <ShinobiEssentials/SEssentialsCarouselInverseCylindrical.h>
#import <ShinobiEssentials/SEssentialsCoverFlow.h>

/**
 
 Primary view controller for the App and currently the only view controller in the
 Storyboard
 
 This view controller manages the presentation of the Editor, Gallery and Inventory
 tabs as well as handling some of their functionality.
 
 Editor: compose and manipulate a scene a prefabricated widgets
 Gallery: browse through a carousel of YouTube videos (presumably to select one for adding
            to the Editor scene)
 Inventory: manipulate a Core Data store for storing a composed Editor scene
 
 Ideally, each tab's functionality would be handled exclusively and internally by it's
 own view controller but we haven't got that far yet e.g. Social Sharing button IBActions
 could be handled in CMDEditorScene and more of BNRInventory would be in BNRInventory classes
 etc.
 
 Once responsibilities are sufficiently partitioned, this is where the
 interesting points of interaction can occur e.g. choosing a video from the gallery to
 add to a scene in the editor or storing a completed scene into the inventory CMS.
 
 */
@interface CMDViewController : UIViewController<SEssentialsTabbedViewDataSource,
                                            SEssentialsCarouselDataSource, SEssentialsCarouselDelegate,
                                            UITableViewDataSource, UITableViewDelegate>

@end
