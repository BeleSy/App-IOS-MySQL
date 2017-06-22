//
//  NetworkActivityIndicatorManager.m
//  33 - MySQL
//
//  Created by Gilles Bénichou on 2017-01-31.
//  Last modified by Gilles Bénichou on 2017-01-31.
//  Copyright © 2017-2017 Gilles Bénichou. All rights reserved.
//

#import "NetworkActivityIndicatorManager.h"
#import <UIKit/UIKit.h>

@interface NetworkActivityIndicatorManager()

@property (nonatomic) NSInteger tasks;
@property (strong, nonatomic, readonly) UIApplication* application;

@end

@implementation NetworkActivityIndicatorManager

@synthesize tasks;
@synthesize application = _application;

- (instancetype)init {
    if(self = [super init]) {
        [self setTasks:0];
    }
    return self;
}

- (UIApplication*)application {
    if (_application == nil) {
        _application = [UIApplication sharedApplication];
    }
    return _application;
}

+ (NetworkActivityIndicatorManager*)sharedManager {
    static NetworkActivityIndicatorManager* sharedInstance = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        sharedInstance = [[NetworkActivityIndicatorManager alloc] init];
    });
    return sharedInstance;
}

- (void)startActivity {
    @synchronized(self) {
        if([[self application] isStatusBarHidden]) {
            return;
        }
        if(![[self application] isNetworkActivityIndicatorVisible]) {
            [[self application] setNetworkActivityIndicatorVisible:YES];
            [self setTasks:0];
        }
        [self setTasks:[self tasks] + 1];
    }
}

- (void)endActivity {
    @synchronized(self) {
        if([[self application] isStatusBarHidden]) {
            return;
        }
        [self setTasks:[self tasks] - 1];
        if ([self tasks] <= 0) {
            [[self application] setNetworkActivityIndicatorVisible:NO];
            [self setTasks:0];
        }
    }
}

- (void)allActivitiesComplete {
    @synchronized(self) {
        if ([[self application] isStatusBarHidden]) {
            return;
        }
        [[self application] setNetworkActivityIndicatorVisible:NO];
        [self setTasks:0];
    }
}

@end
