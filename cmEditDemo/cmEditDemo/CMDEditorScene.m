//
//  CMDEditorScene.m
//  cmEditDemo
//
//  Created by Keith Merrill IV on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CMDEditorScene.h"

@interface CMDEditorScene () 
 
@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKNode *selectedNode;
@property (nonatomic, strong) SKNode *tappedNode;

@end

static NSString * const kMoveableNodeTypeTag = @"movable";
static NSString * const kMoveableVideoTypeTag = @"moveableVideo";

@implementation CMDEditorScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"spaceBkGrnd"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];
        [self addChild:_background];
        
        [self setupPrefabEditorAssets];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime
{
    // @todo - nothing special here yet
}

- (void)didMoveToView:(SKView *)view
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:tapGR];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:panGR];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)tapGR
{
    if (tapGR.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [tapGR locationInView:tapGR.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTap:touchLocation];
    }
}

- (void)selectNodeForTap:(CGPoint)tapLocation
{
    SKSpriteNode *tappedNode = (SKSpriteNode *)[self nodeAtPoint:tapLocation];
    if (![[tappedNode name] isEqualToString:kMoveableVideoTypeTag]) {
        return;
    }
    
	if (![_tappedNode isEqual:tappedNode]) {
		_tappedNode = tappedNode;
        [(SKVideoNode *)_tappedNode play];
	} else {
        [(SKVideoNode *)_tappedNode pause];
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)panGR
{
	if (panGR.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [panGR locationInView:panGR.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForPan:touchLocation];
    } else if (panGR.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGR translationInView:panGR.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [panGR setTranslation:CGPointZero inView:panGR.view];
    } else if (panGR.state == UIGestureRecognizerStateEnded) {
        [_selectedNode removeAllActions];
		[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
    }
}

- (void)selectNodeForPan:(CGPoint)touchLocation
{
   SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    [_selectedNode removeAllActions];
    [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];

    _selectedNode = touchedNode;
    if ([[touchedNode name] isEqualToString:kMoveableNodeTypeTag] ||
       [[touchedNode name] isEqualToString:kMoveableVideoTypeTag]) {
        SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-2.5f) duration:0.1f],
                                                  [SKAction rotateByAngle:0.0 duration:0.1],
                                                  [SKAction rotateByAngle:degToRad(2.5f) duration:0.1f]]];
        [_selectedNode runAction:[SKAction repeatActionForever:sequence]];
    }
}

- (void)panForTranslation:(CGPoint)translation
{
    CGPoint position = [_selectedNode position];
    if ([[_selectedNode name] isEqualToString:kMoveableNodeTypeTag] ||
       [[_selectedNode name] isEqualToString:kMoveableVideoTypeTag]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    }
}

float degToRad(float degree)
{
	return degree / 180.0f * M_PI;
}

- (void)setupPrefabEditorAssets
{
    // setup content title (and logo)
    SKSpriteNode *titleLogo = [SKSpriteNode spriteNodeWithImageNamed:@"catLogo"];
    [titleLogo setName:kMoveableNodeTypeTag];
    [titleLogo setPosition:CGPointMake(titleLogo.frame.size.width / 2.0f - 10.0f, 210.0f)];
    [_background addChild:titleLogo];
    
    // setup ad video
    float offset = 15.0f;
    SKVideoNode *adVideo = [SKVideoNode videoNodeWithVideoFileNamed:@"IMG_0007.MOV"];
    [adVideo setName:kMoveableVideoTypeTag];
    adVideo.size = CGSizeMake(80.0f, 60.0f);
    [adVideo setPosition:CGPointMake(self.frame.size.width - adVideo.frame.size.width / 2.0f, 225.0f + offset)];
    [_background addChild:adVideo];
    
    // setup banner ads
    SKSpriteNode *banner = [SKSpriteNode spriteNodeWithImageNamed:@"catAdBanner3"];
    [banner setName:kMoveableNodeTypeTag];
    [banner setPosition:CGPointMake(banner.frame.size.width / 2.0f, banner.frame.size.height / 2.0f)];
    [_background addChild:banner];
    banner = [SKSpriteNode spriteNodeWithImageNamed:@"catAdBanner"];
    [banner setName:kMoveableNodeTypeTag];
    [banner setPosition:CGPointMake(self.frame.size.width - banner.frame.size.width / 2.0f, banner.frame.size.height / 2.0f)];
    [_background addChild:banner];
    
    // setup content info blurb
    NSString *blurbCopyText = @"10/10 - a feline masterpiece! A UFO is stranded on earth and...";
    SKLabelNode *blurb = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    [blurb setName:kMoveableNodeTypeTag];
    blurb.text = blurbCopyText;
    blurb.fontSize = 14;
    blurb.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame) - 50.0f);
    blurb.fontColor = [UIColor whiteColor];
    [_background addChild:blurb];
}

@end
