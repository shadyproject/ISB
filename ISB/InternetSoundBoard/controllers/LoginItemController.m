//
//  LoginItemController.m
//
//  Created by Christopher Martin on 10/17/14.
//  Copyright (c) 2014 Martin, Christopher. All rights reserved.
//

#import "LoginItemController.h"

@implementation LoginItemController

+ (NSURL*)appPath {
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

+ (void)addAppToLoginItems {
    CFURLRef url = (__bridge CFURLRef)[self appPath];
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst, NULL, NULL, url, NULL, NULL);
        
        if (item) {
            CFRelease(item);
        }
    }
    
    CFRelease(loginItems);
}

+(void)removeAppFromLoginItems {
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    LSSharedFileListItemRef existingItem = [self findItemWithUrl:[self appPath] inFileList:loginItems];
    
    if (existingItem) {
        LSSharedFileListItemRemove(loginItems, existingItem);
    }
    
    CFRelease(loginItems);
}

+(LSSharedFileListItemRef)findItemWithUrl:(NSURL*)itemUrl inFileList:(LSSharedFileListRef)fileList {
    CFURLRef wantedUrl = (__bridge CFURLRef)itemUrl;
    
    NSArray *itemsArray = (__bridge NSArray*) LSSharedFileListCopySnapshot(fileList, NULL);
    
    for (id itemObj in itemsArray) {
        LSSharedFileListItemRef item = (__bridge LSSharedFileListItemRef)itemObj;
        UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
        CFURLRef currentItemUrl = NULL;
        LSSharedFileListItemResolve(item, resolutionFlags, &currentItemUrl, NULL);
        if (currentItemUrl && CFEqual(currentItemUrl, wantedUrl)) {
            CFRelease(currentItemUrl);
            return item;
        }
    }
    return NULL;
}

+(BOOL)appExistsAsLoginItem {
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    LSSharedFileListItemRef appItem = [self findItemWithUrl:[self appPath] inFileList:loginItems];
    
    return (appItem != NULL);
}

@end
