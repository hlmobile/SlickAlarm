//
//  ParentSettingsCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "ParentSettingsCon.h"


@implementation ParentSettingsCon

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.clearsContextBeforeDrawing = NO;
}

- (void)loadArrayData:(BOOL)hasAlarms {

	if ( !controllers ) self->controllers = [[NSMutableArray alloc] init];
	if ( !sections )	self->sections = [[NSMutableArray alloc] init];
	if ( !tableList_0 ) self->tableList_0 = [[NSMutableArray alloc] init];
	if ( !tableList_1 ) self->tableList_1 = [[NSMutableArray alloc] init];
}


- (void)dealloc {
	
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
	}
	
	if ( tableList_1 ) {
		[tableList_1 release];
		self->tableList_1 = nil;
	}
	
	
	if ( controllers ) {
		[controllers release];
		self->controllers = nil;
	}
	
	if ( sections ) {
		[sections release];
		self->sections = nil;
	}
	
    [tableView release];
	
	[super dealloc];
	
}

@end
