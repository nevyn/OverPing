//
//  NSTask+ExceptionSafe.m
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/11/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

#import "NSTask+ExceptionSafe.h"

@implementation NSTask (TCExceptionSafe)
- (nullable NSError *)tc_launchWithoutExceptions
{
    @try {
        [self launch];
        return nil;
    } @catch (NSException *exception) {
        return [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
    }
}
@end
