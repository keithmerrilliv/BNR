//
//  CMDViewController.m
//  cmEditDemo
//
//  Created by Keith Merrill IV on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <ShinobiEssentials/SEssentials.h>

#import "CMDViewController.h"
#import "CMDEditorScene.h"
#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "HomepwnerItemCell.h"

@interface CMDViewController ()
{
    SEssentialsTabbedView *tabbedView;
    SEssentialsCoverFlow *galleryCarousel;
    UITableView *inventoryTable;
    NSMutableArray *inventoryItems;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
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

- (void)setupTabCalled:(NSString*)tabName
{
    SEssentialsTab *tab = [[SEssentialsTab alloc] initWithName:tabName icon:nil];
    [tabbedView addTab:tab atIndex:0];
}

#pragma mark - SEssentialsTabbedViewDataSource methods

- (UIView *)tabbedView:(SEssentialsTabbedView *)_tabbedView contentForTab:(SEssentialsTab *)tab
{
    UIView *tabView;
    if ([tab.name isEqualToString:@"Editor"]) {
        tabView = [self showEditorView:_tabbedView];
    } else if ([tab.name isEqualToString:@"Gallery"]) {
        tabView = [self showGalleryView:_tabbedView];
    } else if ([tab.name isEqualToString:@"Inventory"]) {
        tabView = [self showInventoryView:_tabbedView];
    } else {
        tabView = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    }
    
    return tabView;
}

- (UIView *)showEditorView:(SEssentialsTabbedView *)_tabbedView
{
    SKView *skView = [[SKView alloc] initWithFrame:_tabbedView.contentViewBounds];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    SKScene *scene = [CMDEditorScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
    
    UIView *parent = [[UIView alloc] initWithFrame:_tabbedView.contentViewBounds];
    [parent addSubview:skView];
    [parent addSubview:[self createYouTubeEditorVideo:_tabbedView.contentViewBounds.size]];
    
    return parent;
}

- (UIView *)showGalleryView:(SEssentialsTabbedView *)_tabbedView
{
    [self createYouTubeInventoryVideos];
    galleryCarousel = [[SEssentialsCoverFlow alloc]
                       initWithFrame:_tabbedView.bounds];
    galleryCarousel.dataSource = self;
    galleryCarousel.delegate = self;
    
    return galleryCarousel;
}

- (UIView *)showInventoryView:(SEssentialsTabbedView *)_tabbedView
{
    CGRect frame = CGRectMake(10.0f, 0.0f, 40.0f, 40.0f);
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    addButton.frame = frame;
    [addButton addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    frame.origin.x += addButton.bounds.size.width + 10.0f;
    editButton.frame = frame;
    [editButton addTarget:self action:@selector(editItems:) forControlEvents:UIControlEventTouchUpInside];
    
    inventoryTable = [[UITableView alloc] initWithFrame:_tabbedView.contentViewBounds style:UITableViewStyleGrouped];
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    [inventoryTable registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
    inventoryTable.dataSource = self;
    inventoryTable.delegate = self;
    
    UIView *parentView = [[UIView alloc] init];
    [parentView addSubview:inventoryTable];
    [parentView addSubview:addButton];
    [parentView addSubview:editButton];
    
    return parentView;
}

#pragma mark - SEssentialsTabbedViewDataSource helper methods

- (UIView *)createYouTubeEditorVideo:(CGSize)size
{
    UIWebView *wv = [[UIWebView alloc] init];

    float width = 185.4f;
    float height = 117.6f;
    float x = size.width / 2.0f - width / 2.0f;
    float y = size.height / 2.0f - height / 2.0f;
    wv.frame = CGRectMake(x, y, width, height);
    
    NSString *youTubeURL = @"http://www.youtube.com/embed/9SEaSW1jtnQ";
    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1];
    [html appendString:@"<html><head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head><body style=\"margin:0\">"];
    [html appendFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"%@?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe>", width, height, youTubeURL];
    [html appendString:@"</body></html>"];
    
    [wv loadHTMLString:html baseURL:nil];
    
    return wv;
}

-(void)createYouTubeInventoryVideos
{
    inventoryItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        float width = 309.0f;
        float height = 196.0f;

        UIWebView *wv = [[UIWebView alloc] init];
        float x = 568 / 2.0f - width / 2.0f;
        float y = 320 / 2.0f - height / 2.0f;
        wv.frame = CGRectMake(x, y, width, height);
        
        NSMutableString *htmlBase = [[NSMutableString alloc] initWithCapacity:1];
        [htmlBase appendString:@"<html><head>"];
        [htmlBase appendString:@"<style type=\"text/css\">"];
        [htmlBase appendString:@"body {"];
        [htmlBase appendString:@"background-color: transparent;"];
        [htmlBase appendString:@"color: white;"];
        [htmlBase appendString:@"}"];
        [htmlBase appendString:@"</style>"];
        [htmlBase appendString:@"</head><body style=\"margin:0\">"];
        
        NSString *youTubeIframeAndEndTag;
        switch (i) {
            case 0:
                youTubeIframeAndEndTag = [NSString stringWithFormat:@"%@<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/fUIokQ36rbA?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe></body></html>", htmlBase, width, height];
                break;
            case 1:
                youTubeIframeAndEndTag = [NSString stringWithFormat:@"%@<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/jEruuqRq50g?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe></body></html>", htmlBase, width, height];
                break;
            case 2:
                youTubeIframeAndEndTag = [NSString stringWithFormat:@"%@<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/O9XtK6R1QAk?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe></body></html>", htmlBase, width, height];
                break;
            case 3:
                youTubeIframeAndEndTag = [NSString stringWithFormat:@"%@<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/9DnQLI1XDzI?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe></body></html>", htmlBase, width, height];
                break;
            case 4:
                youTubeIframeAndEndTag = [NSString stringWithFormat:@"%@<iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/Gyf1kjaUZCo?autoplay=1\" allowfullscreen frameborder=\"0\"></iframe></body></html>", htmlBase, width, height];
                break;
        }
        [wv loadHTMLString:youTubeIframeAndEndTag baseURL:nil];
        
        [inventoryItems addObject:wv];
    }
}

#pragma mark - SEssentialsCarouselDataSource methods for gallery tab

- (NSUInteger)numberOfItemsInCarousel:(SEssentialsCarousel *)carousel
{
    return [inventoryItems count];
}

- (UIView *)carousel:(SEssentialsCarousel *)carousel itemAtIndex:(NSInteger)index
{
    return [inventoryItems objectAtIndex:index];
}

#pragma mark - SEssentialsCarouselDelegate methods for gallery tab

-(void)carousel:(SEssentialsCarousel*)carousel_ didTapItem:(UIView*)item atOffset:(CGFloat)offset
{
    // @togo do something interesting like play/pause the selected video
    // currently not working with MOV videos so using YouTube videos instead
}

#pragma mark - UITableViewDataSource and UITableViewDelegate methods for inventory tab

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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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

#pragma mark - IBAction mappings for inventory tab

- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore defaultStore] createItem];
    
    DetailViewController *detailViewController =
    [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        // @todo ensure that calling this doesn't cause some reload view cascade that resets tabbedView
        [inventoryTable reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
}  

- (IBAction)editItems:(id)sender
{
    [inventoryTable setEditing:YES animated:NO];
}

@end
