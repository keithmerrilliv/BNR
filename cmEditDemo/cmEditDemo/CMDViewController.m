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
#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "HomepwnerItemCell.h"

@interface CMDViewController ()
{
    SEssentialsTabbedView *tabbedView;
    SEssentialsCoverFlow *carousel;
    NSMutableArray *items;
    UITableView *tv;
}
@end

@implementation CMDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTabbedView];
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
    [self setupTabCalled:@"Inventory"];
    [self setupTabCalled:@"Gallery"];
    [self setupTabCalled:@"Editor"];
    [self.view addSubview:tabbedView];
    
    tabbedView.dataSource = self;
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
    UIView *tabView;
    if ([tab.name isEqualToString:@"Editor"]) {
        tabView = [self showEditView:_tabbedView];
    } else if ([tab.name isEqualToString:@"Gallery"]) {
        tabView = [self showGalleryView:_tabbedView];
    } else if ([tab.name isEqualToString:@"Inventory"]) {
        tabView = [self showInventoryView:_tabbedView];
    } else {
        tabView = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    }
    
    return tabView;
}

- (UIView *)showInventoryView:(SEssentialsTabbedView *)_tabbedView
{
    UIView *parentView = [[UIView alloc] init];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [addButton addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
//    UITableView *tv
    tv = [[UITableView alloc] initWithFrame:_tabbedView.contentViewBounds style:UITableViewStyleGrouped];
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    [tv registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];

//    ItemsViewController *tvc = [[ItemsViewController alloc] init];
//    [_tabbedView set]
//    tvc.view = tv;
    tv.dataSource = self;
    tv.delegate = self;
    [parentView addSubview:tv];
    [parentView addSubview:addButton];
//    return tv;
//    return tvc.view;
    return parentView;
}

- (UIView *)showEditView:(SEssentialsTabbedView *)_tabbedView
{
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

- (UIView *)showGalleryView:(SEssentialsTabbedView *)_tabbedView
{
    [self createYouTubeVideoViews];
    carousel = [[SEssentialsCoverFlow alloc]
                initWithFrame:_tabbedView.bounds];
    carousel.dataSource = self;
    carousel.delegate = self;
    return carousel;
}

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

#pragma mark - UITableView data source and delegate stuff

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    [[BNRItemStore defaultStore] moveItemAtIndex:[fromIndexPath row]
                                         toIndex:[toIndexPath row]];
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore defaultStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    // Give detail view controller a pointer to the item object in row
    [detailViewController setItem:selectedItem];
    
    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore defaultStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore defaultStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItem *p = [[[BNRItemStore defaultStore] allItems]
                  objectAtIndex:[indexPath row]];
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    return cell;
}

- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore defaultStore] createItem];
    
    DetailViewController *detailViewController =
    [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
//        [[self tableView] reloadData];
//        [tv reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
}  

@end
