//
//  ISUSoundEffect.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-10.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSoundEffect.h"
#import <AudioToolbox/AudioServices.h>

@interface ISUSoundEffect ()

@property (nonatomic, assign) SystemSoundID soundID;

@end

@implementation ISUSoundEffect
+ (id)soundEffectWithContentsOfFile:(NSString *)aPath
{
    if (aPath)
    {
        return [[ISUSoundEffect alloc] initWithContentsOfFile:aPath];
    }
    return nil;
}

- (id)initWithContentsOfFile:(NSString *)path
{
    self = [super init];
    
    if (self != nil)
    {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        if (aFileURL != nil)
        {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError)
            { // success
                _soundID = aSoundID;
            }
            else
            {
                NSLog(@"Error (%zd) loading sound at path: %@", error, path);
                self = nil;
            }
        }
        else
        {
            NSLog(@"NSURL is nil for path: %@", path);
            self = nil;
        }
    }
    return self;
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
}

-(void)play
{
    AudioServicesPlaySystemSound(_soundID);
}

@end
