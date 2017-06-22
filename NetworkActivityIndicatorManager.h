//
//  NetworkActivityIndicatorManager.h
//  33 - MySQL
//
//  Created by Gilles Bénichou on 2017-01-31.
//  Last modified by Gilles Bénichou on 2017-01-31.
//  Copyright © 2017-2017 Gilles Bénichou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivityIndicatorManager : NSObject

// Get class singleton
+ (NetworkActivityIndicatorManager*)sharedManager;

// Show network activity indicator
// Each call adds an activity to the internal queue
- (void)startActivity;

// Hide network activity indicator
// Will not hide the indicator until all activities are complete
- (void)endActivity;

// Hide the network activity indicator
// This will hide the indicator regardless of how many activities have been started
- (void)allActivitiesComplete;

@end
