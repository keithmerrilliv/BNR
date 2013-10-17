//
//  CMDViewController.m
//  cmEditDemo
//
//  Created by Keith Merrill IV on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <ShinobiEssentials/SEssentials.h>

#import "CMDViewController.h"
#import "CMDMyScene.h"

@interface CMDViewController ()
{
    SEssentialsTabbedView *tabbedView;
//    SEssentialsCarouselLinear2D *carousel;
//    SEssentialsCarouselInverseCylindrical *carousel;
    SEssentialsCoverFlow *carousel;
    NSMutableArray *items;
}
@end

@implementation CMDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    
//    // Create and configure the scene.
//    SKScene * scene = [CMDMyScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
//    
//    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        viewController = [[CMDViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//    } else {
//        viewController = [[CMDViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    }
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
    
    [self showTabbedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [tabbedView activateTabDisplayedAtIndex:1];
//    [tabbedView activateTabDisplayedAtIndex:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [tabbedView activateTabDisplayedAtIndex:0];
}

- (UIView *)SKSceneInTabWithBounds:(CGRect)bounds
{
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Create and configure the scene.
    CGSize size = CGSizeMake(10.0f, 10.0f);
//    SKScene *scene = [CMDMyScene sceneWithSize:bounds.size];
    SKScene *scene = [CMDMyScene sceneWithSize:size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    
    return skView;
}

- (void)showTabbedView
{
    tabbedView = [[SEssentialsTabbedView alloc] initWithFrame:self.view.bounds];
    [self setupTabCalled:@"Videos"];
    [self setupTabCalled:@"Editor"];
//    [self setupTabCalled:@"Welcome"];
//    [tabbedView activateTabDisplayedAtIndex:1];
    [self.view addSubview:tabbedView];
    
//    [tabbedView removeTabDisplayedAtIndex:0];
    
    tabbedView.dataSource = self;
//    tabbedView.hasNewTabButton = YES;
    tabbedView.editable = NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - SEssentialsTabbedViewDataSource methods

- (SEssentialsTab *)tabForTabbedView:(SEssentialsTabbedView *)tabbedView
{
    SEssentialsTab *tab = [[SEssentialsTab alloc] initWithName:@"New Tab" icon:nil];
    return tab;
}

- (UIView *)tabbedView:(SEssentialsTabbedView *)_tabbedView contentForTab:(SEssentialsTab *)tab
{
//    return [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
//    return [self showEditView:_tabbedView];
//    return [self showCMView:_tabbedView];
    UIView *tabView;
    if ([tab.name isEqualToString:@"Editor"]) {
        tabView = [self showEditView:_tabbedView];
    } else if ([tab.name isEqualToString:@"Videos"]) {
        tabView = [self showCMView:_tabbedView];
    } else {
        tabView = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    }
    
    return tabView;
}

- (UIView *)showEditView:(SEssentialsTabbedView *)_tabbedView
{
    //    UIView *view = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    //    [view addSubview:[self SKSceneInTabWithBounds:_tabbedView.contentViewBounds]];
    //    return view;
    //    return [self SKSceneInTabWithBounds:_tabbedView.contentViewBounds];
    
    UIView *parent = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    
    float width = 309.0f;
    float height = 196.0f;
    
    UIWebView *wv = [[UIWebView alloc] init];
    float x = _tabbedView.contentViewBounds.size.width / 2.0f -
            width / 2.0f;
    float y = _tabbedView.contentViewBounds.size.height / 2.0f -
            height / 2.0f;
    NSInteger toolbarWidth = 50;
    wv.frame = CGRectMake(x + toolbarWidth, y, width, height);
    
    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1];
    [html appendString:@"<html><head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head><body style=\"margin:0\">"];
    [html appendFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/Gyf1kjaUZCo?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe>", width, height];
    [html appendString:@"</body></html>"];
    
    [wv loadHTMLString:html baseURL:nil];
    
    SKView *skView = [[SKView alloc] initWithFrame:_tabbedView.contentViewBounds];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene *scene = [CMDMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    
    [parent addSubview:skView];
    [parent addSubview:wv];
    
    //    return [[SKView alloc] initWithFrame:_tabbedView.contentViewBounds];
    //    return skView;
    return parent;
}

//#import "GTMOAuth2ViewControllerTouch.h"
//#import "GTL/GTLUtilities.h"
//#import "GTMOAuth2ViewControllerTouch.h"
- (UIView *)showCMView:(SEssentialsTabbedView *)_tabbedView
{
    // Load the OAuth 2 token from the keychain, if it was previously saved.
//    NSString *clientID = @"853742039935.apps.googleusercontent.com"; //[_clientIDField stringValue];
//    NSString *clientSecret = @"1YDFuti-2kJTK0p942sRaQcm"; //[_clientSecretField stringValue];
//    
//    GTMOAuth2Authentication *auth =
//    [GTMOAuth2WindowController authForGoogleFromKeychainForName:kKeychainItemName
//                                                       clientID:clientID
//                                                   clientSecret:clientSecret];
//    self.youTubeService.authorizer = auth;
//    return nil;
    
    [self createYouTubeVideoViews];
//    carousel = [[SEssentialsCarouselLinear2D alloc]
//    carousel = [[SEssentialsCarouselInverseCylindrical alloc]
    carousel = [[SEssentialsCoverFlow alloc]
                initWithFrame:_tabbedView.bounds];
    carousel.dataSource = self;
    carousel.delegate = self;
    return carousel;
}

//-(void)createGalleryVideoViews
//{
//    items = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < 10; i++)
//    {
//        //        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        //        item.backgroundColor = [UIColor grayColor];
//        //        item.text = [NSString stringWithFormat:@"%d", i];
//        //        item.textAlignment = NSTextAlignmentCenter;
//
//}

-(void)createYouTubeVideoViews
{
    items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i++)
    {
//        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        item.backgroundColor = [UIColor grayColor];
//        item.text = [NSString stringWithFormat:@"%d", i];
        //        item.textAlignment = NSTextAlignmentCenter;
        float width = 309.0f;
        float height = 196.0f;

        UIWebView *wv = [[UIWebView alloc] init];
        float x = 568 / 2.0f -
        width / 2.0f;
        float y = 320 / 2.0f -
        height / 2.0f;
        wv.frame = CGRectMake(x, y, width, height);
        
        NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1];
        [html appendString:@"<html><head>"];
        [html appendString:@"<style type=\"text/css\">"];
        [html appendString:@"body {"];
        [html appendString:@"background-color: transparent;"];
        [html appendString:@"color: white;"];
        [html appendString:@"}"];
        [html appendString:@"</style>"];
        [html appendString:@"</head><body style=\"margin:0\">"];
        [html appendFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/Gyf1kjaUZCo?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe>", width, height];
        [html appendString:@"</body></html>"];
        
        [wv loadHTMLString:html baseURL:nil];

        [items addObject:wv];
    }
}

- (NSUInteger)numberOfItemsInCarousel:(SEssentialsCarousel *)carousel
{
    return [items count];
}

- (UIView *)carousel:(SEssentialsCarousel *)carousel itemAtIndex:(NSInteger)index
{
    return [items objectAtIndex:index];
}

-(void)carousel:(SEssentialsCarousel*)carousel_ didTapItem:(UIView*)item atOffset:(CGFloat)offset
{
//    [(UIWebView *)item reload];
//    float width = 309.0f;
//    float height = 196.0f;
//
//    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1];
//    [html appendString:@"<html><head>"];
//    [html appendString:@"<style type=\"text/css\">"];
//    [html appendString:@"body {"];
//    [html appendString:@"background-color: transparent;"];
//    [html appendString:@"color: white;"];
//    [html appendString:@"}"];
//    [html appendString:@"</style>"];
//    [html appendString:@"</head><body style=\"margin:0\">"];
//    [html appendFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/Gyf1kjaUZCo?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe>", width, height];
//    [html appendString:@"</body></html>"];
//    
//    [(UIWebView *)item loadHTMLString:html baseURL:nil];
    [items removeObjectIdenticalTo:item];
    [carousel reloadData];
}

-(void)carousel:(SEssentialsCarousel*)carousel willDisplayItem:(UIView*)item atOffset:(CGFloat)offset
{
//    [(UIWebView *)item reload];
}

#pragma mark - Utility methods

- (void)setupTabCalled:(NSString*)tabName
{
    SEssentialsTab *tab = [[SEssentialsTab alloc] initWithName:tabName icon:nil];
    [tabbedView addTab:tab atIndex:0];
}

@end
