//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Keith Merrill on 7/2/13.
//  Copyright (c) 2013 Keith Merrill. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BNRItem.h"
//@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)p;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;

@end
