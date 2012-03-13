//
//  ITScatterSound.h
//  ITScatterSoundTests
//
//  Created by Patrick Perini on 3/4/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Notifications
extern NSString *const ITScatterSoundDidStartNotification;
extern NSString *const ITScatterSoundDidPlayNotification;
extern NSString *const ITScatterSoundDidStopNotification;

#pragma mark - Keys
extern NSString *const ITScatterSoundDidPlay;

#pragma mark - Public Interface
@interface ITScatterSound : NSObject
{
    @private
    NSDate *endTime;
    NSDate *lastPlayTime;
}

@property (nonatomic, retain) NSSound *sound;
@property (nonatomic) NSTimeInterval  longestPeriod;     // e.g. No less than once per day     (86400)
@property (nonatomic) NSTimeInterval  shortestPeriod;    // e.g. No more than every 30 seconds (30)
@property (nonatomic) NSTimeInterval  duration;          // e.g. The next 5 hours              (18000)

- (id)initWithSound: (NSSound *)aSound;
- (id)initWithSound: (NSSound *)aSound period:        (NSTimeInterval)period;
- (id)initWithSound: (NSSound *)aSound longestPeriod: (NSTimeInterval)longest  shortestPeriod: (NSTimeInterval)shortest;
- (id)initWithSound: (NSSound *)aSound period:        (NSTimeInterval)period   duration:       (NSTimeInterval)duration;
- (id)initWithSound: (NSSound *)aSound longestPeriod: (NSTimeInterval)longest  shortestPeriod: (NSTimeInterval)shortest duration: (NSTimeInterval)duration;

- (void)start;
- (void)stop;

@end
