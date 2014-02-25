//
//  CMDMyScene.h
//  cmEditDemo
//
//  Created by Keith Merrill IV on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 
 Primary view for the App's three tab interface used for editing and composing a scene
 
 This view comprises a prefabricated SpriteKit scene with elements 
 (sprites, videos, text labels and buttons) that respond to tap and pan gestures.
 
 In particular, sprites and text labels can be repositioned by dragging (pan gesture).
 Videos will toggle play when tapped (and the one in the upper right corner can also be dragged).
 Buttons leverage the iOS Social Framework for presenting Twitter or Facebook compose views
 
 */
@interface CMDEditorScene : SKScene

@end
