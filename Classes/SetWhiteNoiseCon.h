//
//  SetWhiteNoiseCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ParentSettingsCon.h"


@interface SetWhiteNoiseCon : ParentSettingsCon {
    int selectedRow;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@end
