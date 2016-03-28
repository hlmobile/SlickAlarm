//
//  SetMusicCon.h
//  SlickTime
//
//  Created by Jin Bei on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ParentSettingsCon.h"

@class SetAlarmViewCon;

@interface SetMusicCon : ParentSettingsCon <MPMediaPickerControllerDelegate> {
    int isEditing;
    int selectedRow;
}


@property (nonatomic, assign) SetAlarmViewCon *vcParent;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sgmMusic;
@property (nonatomic, retain) UIButton *editButton;

- (IBAction)segmentButtonPressed:(id)sender;

@end