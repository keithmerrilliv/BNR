//
//  CMDViewController.h
//  cmEditDemo
//

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <ShinobiEssentials/SEssentialsTabbedView.h>
#import <ShinobiEssentials/SEssentialsCarouselLinear2D.h>
#import <ShinobiEssentials/SEssentialsCarouselInverseCylindrical.h>
#import <ShinobiEssentials/SEssentialsCoverFlow.h>

@interface CMDViewController : UIViewController<SEssentialsTabbedViewDataSource,
SEssentialsCarouselDataSource, SEssentialsCarouselDelegate>

@end
