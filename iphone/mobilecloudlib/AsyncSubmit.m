/**
 * Copyright (c) {2003,2010} {openmobster@gmail.com} {individual contributors as indicated by the @authors tag}.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

#import "AsyncSubmit.h"


/**
 * 
 * @author openmobster@gmail.com
 */
@implementation AsyncSubmit

-init
{
	if([super init] == self)
	{
		queue = [[NSOperationQueue alloc] init];
	}
	return self;
}

-(void)dealloc
{
	[queue release];
	/*if(activityIndicator != nil)
	{
		[activityIndicator release];
	}*/
	if(activityIndicatorView != nil)
	{
		[activityIndicatorView release];
	}
	[super dealloc];
}

+(id)withInit:(UIViewController *) caller
{
	AsyncSubmit *instance = [[AsyncSubmit alloc] init];
	instance = [instance autorelease];
	
	instance->caller = caller;
	
	return instance;
}

-(void)start
{
	//Start the Activity Indicators
	activityIndicatorView = [[ActivityIndicatorView alloc] initWithNibName:@"ActivityIndicatorView" bundle:nil];
	
	//Disable the screen from interactions
	[caller.view setUserInteractionEnabled:NO];
	if(caller.navigationController != nil)
	{
		[caller.navigationController.view setUserInteractionEnabled:NO];
	}
	if(caller.parentViewController != nil)
	{
		[caller.parentViewController.view setUserInteractionEnabled:NO];
	}
	if(caller.tabBarController != nil)
	{
		[caller.tabBarController.view setUserInteractionEnabled:NO];
	}
	
	[caller.view addSubview:activityIndicatorView.view];
	[caller.view bringSubviewToFront:activityIndicatorView.view];
	
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(execute) object:nil];	
	operation = [operation autorelease];
	
	//Add the operation to the queue
	[queue addOperation:operation];
}

-(void)execute
{
	[NSThread sleepForTimeInterval:5];
	[self performSelectorOnMainThread:@selector(callback) withObject:self waitUntilDone:NO];
}

-(void)callback
{
	//Stop the Activity Indicator
	[activityIndicatorView.view removeFromSuperview];
	
	if(caller.navigationController != nil)
	{
		[caller.navigationController.view setUserInteractionEnabled:YES];
	}
	if(caller.parentViewController != nil)
	{
		[caller.parentViewController.view setUserInteractionEnabled:YES];
	}
	if(caller.tabBarController != nil)
	{
		[caller.tabBarController.view setUserInteractionEnabled:YES];
	}
	[caller.view setUserInteractionEnabled:YES];
	[caller asyncCallback];
}
@end
