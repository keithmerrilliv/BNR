//
//  CMDMyScene.m
//  DragDrop
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "CMDMyScene.h"

@interface CMDMyScene () 
 
@property (nonatomic, strong) SKSpriteNode *background;
//@property (nonatomic, strong) SKSpriteNode *selectedNode;
@property (nonatomic, strong) SKNode *selectedNode;
@property (nonatomic, strong) SKNode *tappedNode;

@end

static NSString * const kAnimalNodeName = @"movable";

@implementation CMDMyScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
 
        // 1) Loading the background
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"blue-shooting-stars"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];
        [self addChild:_background];
 
        // 2) Loading the images
        NSArray *imageNames = @[@"bird", @"cat", @"dog", @"turtle"];
        for(int i = 0; i < [imageNames count]; ++i) {
          NSString *imageName = [imageNames objectAtIndex:i];
          SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
          [sprite setName:kAnimalNodeName];
 
          float offsetFraction = ((float)(i + 1)) / ([imageNames count] + 1);
          [sprite setPosition:CGPointMake(size.width * offsetFraction, size.height / 2)];
          [_background addChild:sprite];
            
//            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"System"];
//            [label setName:kAnimalNodeName];
//            label.text = @"Holy Shit!";
//            label.fontColor = [UIColor blackColor];
//            [label setPosition:CGPointMake(size.width * offsetFraction / 2.0f, size.height / 2.0f)];
//            [_background addChild:label];

            SKVideoNode *video = [SKVideoNode videoNodeWithVideoFileNamed:@"IMG_0652.MOV"];
//            [video setName:kAnimalNodeName];
            [video setName:@"video"];
//            video.size = CGSizeMake(video.size.width / 100.0f, video.size.height / 100.0f);
//            video.size = CGSizeMake(270.0f, 480.0f);
            video.size = CGSizeMake(80.0f, 60.0f);
            [video setPosition:CGPointMake(size.width * offsetFraction / 2.0f, size.height / 2.0f)];
            [_background addChild:video];
            [video play];
        }
    }
 
    return self;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint positionInScene = [touch locationInNode:self];
//    [self selectNodeForTouch:positionInScene];
//}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
   //1
   SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
 
      //2
	if(![_selectedNode isEqual:touchedNode]) {
		[_selectedNode removeAllActions];
		[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
 
		_selectedNode = touchedNode;
		//3
		if([[touchedNode name] isEqualToString:kAnimalNodeName] ||
           [[touchedNode name] isEqualToString:@"video"]) {
			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
													  [SKAction rotateByAngle:0.0 duration:0.1],
													  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			[_selectedNode runAction:[SKAction repeatActionForever:sequence]];
		}
	}
}

- (void)selectNodeForTap:(CGPoint)touchLocation {
    //1
    SKSpriteNode *tappedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //2
	if(![_tappedNode isEqual:tappedNode]) {
		[_tappedNode removeAllActions];
//		[_tappedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        
		_tappedNode = tappedNode;
		//3
		if([[tappedNode name] isEqualToString:@"video"]) {
//			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
//													  [SKAction rotateByAngle:0.0 duration:0.1],
//													  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
//			[_tappedNode runAction:[SKAction repeatActionForever:sequence]];
            [(SKVideoNode *)_tappedNode pause];
		}
	}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}

//- (CGPoint)boundLayerPos:(CGPoint)newPos {
//    CGSize winSize = self.size;
//    CGPoint retval = newPos;
//    retval.x = MIN(retval.x, 0);
//    retval.x = MAX(retval.x, -[_background size].width+ winSize.width);
//    retval.y = [self position].y;
//    return retval;
//}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:kAnimalNodeName] ||
       [[_selectedNode name] isEqualToString:@"video"]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
//    else {
//        CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
//        [_background setPosition:[self boundLayerPos:newPos]];
//    }
}

- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:tapGR];
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//	CGPoint positionInScene = [touch locationInNode:self];
//	CGPoint previousPosition = [touch previousLocationInNode:self];
// 
//	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
// 
//	[self panForTranslation:translation];
//}

- (void)handleTapFrom:(UITapGestureRecognizer *)tr
{
    if (tr.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [tr locationInView:tr.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTap:touchLocation];
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
 
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
 
        touchLocation = [self convertPointFromView:touchLocation];
 
        [self selectNodeForTouch:touchLocation];
 
 
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
 
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
 
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
 
//        if (![[_selectedNode name] isEqualToString:kAnimalNodeName]) {
//            float scrollDuration = 0.2;
//            CGPoint velocity = [recognizer velocityInView:recognizer.view];
//            CGPoint pos = [_selectedNode position];
//            CGPoint p = mult(velocity, scrollDuration);
//       
//            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
//            newPos = [self boundLayerPos:newPos];
//            [_selectedNode removeAllActions];
//       
//            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
//            [moveTo setTimingMode:SKActionTimingEaseOut];
//            [_selectedNode runAction:moveTo];
//        }
 
    }
}

CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}

@end
