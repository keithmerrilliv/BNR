//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Keith Merrill IV on 4/16/14.
//  Copyright (c) 2014 Keith Merrill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (BNRImageStore *)sharedStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
