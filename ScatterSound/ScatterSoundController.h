//
//  ScatterSoundController.h
//  ScatterSound
//
//  Created by Patrick Perini on 3/8/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ITScatterSound;
@class ITFileWell;
@class AppDelegate;

typedef enum
{
    ScatterSoundPlayButtonState,
    ScatterSoundPauseButtonState
} ScatterSoundButtonState;

@interface ScatterSoundController : NSObject <NSTextFieldDelegate>
{
    @private
    AppDelegate *appDelegate;
    ITScatterSound *scatterSound;
    ScatterSoundButtonState playPauseButtonState;
}

@property (nonatomic, retain) IBOutlet  ITFileWell  *fileWell;

@property (nonatomic, retain, readonly) NSArray     *intervalFields;
@property (nonatomic, retain) IBOutlet  NSTextField *minimumHoursField;
@property (nonatomic, retain) IBOutlet  NSTextField *minimumMinutesField;
@property (nonatomic, retain) IBOutlet  NSTextField *minimumSecondsField;
@property (nonatomic, retain) IBOutlet  NSTextField *maximumHoursField;
@property (nonatomic, retain) IBOutlet  NSTextField *maximumMinutesField;
@property (nonatomic, retain) IBOutlet  NSTextField *maximumSecondsField;

@property (nonatomic, retain) IBOutlet  NSButton    *playPauseButton;

- (void)fileWellDidReceiveDraggedFile:(NSNotification *)notification;
- (IBAction)browseButtonWasPressed:(id)sender;
- (IBAction)playPauseButtonWasPressed:(id)sender;

@end
