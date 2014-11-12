//
//  LoginItemController.h
//
//  Created by Christopher Martin on 10/17/14.
//

#import <Foundation/Foundation.h>

@interface LoginItemController : NSObject

+(void)addAppToLoginItems;
+(void)removeAppFromLoginItems;

+(BOOL)appExistsAsLoginItem;

@end
