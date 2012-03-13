//
//  ScatterSoundController.m
//  ScatterSound
//
//  Created by Patrick Perini on 3/8/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import "ScatterSoundController.h"
#import "AppDelegate.h"
#import "ITScatterSound.h"
#import "ITTimeIntervalFormatter.h"
#import "ITFileWell.h"

@implementation ScatterSoundController (Private)

- (void)setScatterSoundWithSound:(NSSound *)sound longestPeriod:(NSTimeInterval)longPeriod shortestPeriod:(NSTimeInterval)shortPeriod
{
    if (scatterSound)
    {
        [scatterSound stop];
    }
    
    scatterSound = [[ITScatterSound alloc] initWithSound: sound
                                           longestPeriod: longPeriod
                                          shortestPeriod: shortPeriod];
    if (sound)
    {
        [[NSApp mainWindow] setTitle: [NSString stringWithFormat: @"ScatterSound - %@", sound.name]];
        [self.playPauseButton setEnabled: YES];
    }
    else
    {
        [[NSApp mainWindow] setTitle: @"ScatterSound"];
        [self.playPauseButton setEnabled: NO];
    }
}

@end

@implementation ScatterSoundController

@synthesize fileWell;

@synthesize intervalFields;
@synthesize minimumHoursField;
@synthesize minimumMinutesField;
@synthesize minimumSecondsField;
@synthesize maximumHoursField;
@synthesize maximumMinutesField;
@synthesize maximumSecondsField;

@synthesize playPauseButton;

- (id)init
{
    self = [super init];
    if (self)
    {
        appDelegate = (AppDelegate *)[NSApp delegate];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(fileWellDidReceiveDraggedFile:)
                                                     name: ITFileWellDidReceiveDraggedFile
                                                   object: nil];
    }
    return self;
}

- (void)awakeFromNib
{
    intervalFields = [NSArray arrayWithObjects: minimumHoursField,
                                                minimumMinutesField,
                                                minimumSecondsField,
                                                maximumHoursField,
                                                maximumMinutesField,
                                                maximumSecondsField, nil];
    
    ITTimeIntervalFormatter *intervalFormatter = [[ITTimeIntervalFormatter alloc] init];
    for (NSTextField *intervalField in intervalFields)
    {
        [intervalField setDelegate: self];
        [intervalField setFormatter: intervalFormatter];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSTimeInterval shortestPerdiod = (minimumHoursField.stringValue.intValue * 60 * 60) +
                                     (minimumMinutesField.stringValue.intValue * 60)    +
                                     (minimumSecondsField.stringValue.intValue);
    NSTimeInterval longestPeriod = (maximumHoursField.stringValue.intValue * 60 * 60) +
                                   (maximumMinutesField.stringValue.intValue * 60)    +
                                   (maximumSecondsField.stringValue.intValue);
    
    [self setScatterSoundWithSound: scatterSound.sound
                     longestPeriod: longestPeriod
                    shortestPeriod: shortestPerdiod];
}

- (void)fileWellDidReceiveDraggedFile:(NSNotification *)notification
{
    NSTimeInterval shortestPerdiod = (minimumHoursField.stringValue.intValue * 60 * 60) +
                                     (minimumMinutesField.stringValue.intValue * 60)    +
                                     (minimumSecondsField.stringValue.intValue);
    NSTimeInterval longestPeriod = (maximumHoursField.stringValue.intValue * 60 * 60) +
                                   (maximumMinutesField.stringValue.intValue * 60)    +
                                   (maximumSecondsField.stringValue.intValue);
    
    NSSound *sound = [[NSSound alloc] initWithContentsOfURL: notification.object byReference: NO];
    [sound setName: [notification.object lastPathComponent]];
    
    [self setScatterSoundWithSound: sound
                     longestPeriod: longestPeriod
                    shortestPeriod: shortestPerdiod];
}

- (IBAction)browseButtonWasPressed:(id)sender
{
    NSTimeInterval shortestPerdiod = (minimumHoursField.stringValue.intValue * 60 * 60) +
                                     (minimumMinutesField.stringValue.intValue * 60)    +
                                     (minimumSecondsField.stringValue.intValue);
    NSTimeInterval longestPeriod = (maximumHoursField.stringValue.intValue * 60 * 60) +
                                   (maximumMinutesField.stringValue.intValue * 60)    +
                                   (maximumSecondsField.stringValue.intValue);
    
    NSOpenPanel *fileOpenPanel = [NSOpenPanel openPanel];
    [fileOpenPanel setCanChooseFiles: YES];
    [fileOpenPanel setAllowedFileTypes: [NSSound soundUnfilteredTypes]];
    
    [fileOpenPanel beginSheetModalForWindow: [NSApp mainWindow]
                          completionHandler: ^(NSInteger result)
                          {
                              if (result == NSFileHandlingPanelOKButton)
                              {
                                  [fileOpenPanel close];
                                  
                                  NSURL *fileURL = [fileOpenPanel URL];
                                  NSSound *sound = [[NSSound alloc] initWithContentsOfURL: fileURL byReference: NO];
                                  [sound setName: [fileURL lastPathComponent]];
                                  
                                  [self setScatterSoundWithSound: sound
                                                   longestPeriod: longestPeriod
                                                  shortestPeriod: shortestPerdiod];
                              }
                          }];
}

- (IBAction)playPauseButtonWasPressed:(id)sender
{
    switch (playPauseButtonState)
    {
        case ScatterSoundPlayButtonState:
        {
            [scatterSound start];
            
            playPauseButtonState = ScatterSoundPauseButtonState;
            [playPauseButton setImage: [NSImage imageNamed: @"pause"]];
            [playPauseButton setAlternateImage: [NSImage imageNamed: @"pause-pressed"]];
            
            break;
        }
            
        case ScatterSoundPauseButtonState:
        {
            [scatterSound stop];
            
            playPauseButtonState = ScatterSoundPlayButtonState;
            [playPauseButton setImage: [NSImage imageNamed: @"play"]];
            [playPauseButton setAlternateImage: [NSImage imageNamed: @"play-pressed"]];
            
            break;
        }
    }
}

@end
