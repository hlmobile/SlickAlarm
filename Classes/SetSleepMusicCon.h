//
//  SetSleepMusicCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"
#import "MediaPlayer/MediaPlayer.h"

@interface SetSleepMusicCon : ParentSettingsCon <MPMediaPickerControllerDelegate> {
    BOOL isEditing;
}

@property (nonatomic, assign) NSMutableArray *musicList;
@property (nonatomic, retain) UIButton *editButton;

- (void)editButtonPressed:(id)sender;
- (void)backButtonPressed:(id)sender;
@end
