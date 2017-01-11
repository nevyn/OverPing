//
//  NSTask+ExceptionSafe.h
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/11/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (TCExceptionSafe)
- (nullable NSError *)tc_launchWithoutExceptions;
@end
