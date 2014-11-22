/* $Id: LegoNXTRemote.m 17 2009-02-01 01:18:33Z querry43 $ */

/*! \file LegoNXTRemote.h
* This file implements a graphical interface for the LegoNXT Framework.
*
* \author Matt Harrington
* \date 01/04/09
*/

#import "LegoNXTRemote.h"

// This variable defines how often the sensors poll values
#define SENSOR_TIME 0.01

@implementation LegoNXTRemote

// enable all poll buttons
- (void)enableControls:(BOOL)enable
{
    [sensorPoll1 setEnabled:enable];
    [sensorPoll2 setEnabled:enable];
    
    [sensorType1 setEnabled:enable];
    [sensorType2 setEnabled:enable];
    
    [servoPollA setEnabled:enable];
    
    [servoPositionReset setEnabled:enable];
    
    if ( ! enable )
    {
        [sensorPoll1 setTitle:@"Poll"];
        [sensorPoll2 setTitle:@"Poll"];
        
        [servoPollA setTitle:@"Poll"];
        
        int i ;
        
        for ( i = 0; i < 2; i++ )
            isPollingSensor[i] = NO;
        for ( i = 0; i < 1; i++ )
            isPollingServo[i] = NO;
    }
}


// begin polling a sensor
- (void)startPollingSensor:(BOOL)start
                sensorPort:(UInt8)port
            sensorSelector:(NSPopUpButton*)sensorSelector
                pollButton:(NSButton*)pollButton
{
    NSString *sensorType = [sensorSelector titleOfSelectedItem];
    
    if (start)
    {
        // setup sensor
       // NSLog(@"startPollingSensor: setup sensor");
        if (sensorType == nil)
            [_nxt setupLightSensor:port active:YES];
        else if ([sensorType isEqualToString:@"Touch"])
            [_nxt setupTouchSensor:port];
        else if ([sensorType isEqualToString:@"Light"])
            [_nxt setupLightSensor:port active:YES];
        else if ([sensorType isEqualToString:@"Light Passive"])
            [_nxt setupLightSensor:port active:NO];
        else
        {
           // NSLog(@"startPollingSensor: unknown sensor type");
            return;
        }
        
        
        // start polling
       // NSLog(@"startPollingSensor: start polling");
        [_nxt pollSensor:port interval:SENSOR_TIME];
        
        [pollButton setTitle:@"Stop"];
        [sensorSelector setEnabled:NO];
    }
    
    else
    {
        [_nxt pollSensor:port interval:0];
        
        [pollButton setTitle:@"Poll"];
        [sensorSelector setEnabled:YES];
    }
}


// begin polling a servo
- (void)startPollingServo:(BOOL)start
                servoPort:(UInt8)port
               pollButton:(NSButton*)pollButton
{
    if ( start )
    {
     //   NSLog(@"startPollingServo: start polling");
        [_nxt pollServo:port interval:SENSOR_TIME];
        [pollButton setTitle:@"Stop"];
    }
    else
    {
        [_nxt pollServo:port interval:0];
        [pollButton setTitle:@"Poll"];
    }
}

- (void)setSensorTextField:(UInt8)port value:(NSString*)value
{
    switch ( port )
    {
        case kNXTSensor1:
            [sensorValue1 setStringValue:value];
            break;
        case kNXTSensor2:
            [sensorValue2 setStringValue:value];
            break;
        case kNXTSensor3:
            [servoPositionA setStringValue:value];
            break;
    }
}


#pragma mark -
#pragma mark GUI Delegates

- (id)awakeFromNib
{
    [NSApp setDelegate:self];
    
    // set a status label
    [connectMessage setStringValue:[NSString stringWithFormat:@"Disconnected"]];
    
    return self;
}

- (BOOL)windowShouldClose:(id)sender
{
    [NSApp terminate:self];
    return true;
}

- (IBAction)doConnect:(id)sender
{
    [connectMessage setStringValue:[NSString stringWithFormat:@"Connecting..."]];
	
    _nxt = [[NXT alloc] init];
    [_nxt connect:self];
}

- (IBAction)doPollSensor1:(id)sender
{    
    if ( isPollingSensor[0] )
        isPollingSensor[0] = NO;
    else
        isPollingSensor[0] = YES;
    
    [self startPollingSensor:isPollingSensor[0] sensorPort:kNXTSensor1 sensorSelector:sensorType1 pollButton:sensorPoll1];
}

- (IBAction)doPollSensor2:(id)sender
{
    if ( isPollingSensor[1] )
        isPollingSensor[1] = NO;
    else
        isPollingSensor[1] = YES;
    
    [self startPollingSensor:isPollingSensor[1] sensorPort:kNXTSensor2 sensorSelector:sensorType2 pollButton:sensorPoll2];
}

- (IBAction)doPollSensor3:(id)sender
{
    if ( isPollingSensor[2] )
        isPollingSensor[2] = NO;
    else
        isPollingSensor[2] = YES;
    
    [self startPollingSensor:isPollingSensor[2] sensorPort:kNXTSensor3 sensorSelector:nil pollButton:servoPollA];
}

- (IBAction)doPollServoA:(id)sender
{
    if ( isPollingServo[0] )
        isPollingServo[0] = NO;
    else
        isPollingServo[0] = YES;
    
    [self startPollingServo:isPollingServo[0] servoPort:kNXTMotorA pollButton:servoPollA];
}

- (IBAction)doResetServoPosition:(id)sender
{
    [_nxt resetMotorPosition:kNXTMotorA relative:YES];
    
    [servoPositionA setStringValue:@""];
}


#pragma mark -
#pragma mark NXT Delegates

// connected
- (void) NXTDiscovered:(NXT*)nxt
{
    [connectMessage setStringValue:[NSString stringWithFormat:@"Connected"]];
    [connectButton setEnabled:NO];
    [self enableControls:YES];
    
	[nxt playTone:523 duration:500];
    [nxt getBatteryLevel];
    [nxt pollKeepAlive];
    
    // Start Touch Sensor
    [self doPollSensor1:nil];
    // Start Light Sensor
    [self doPollSensor2:nil];
    [self doPollSensor3:nil];
    // Start Motor Sensor
    //[self doPollServoA:nil];
}


// disconnected
- (void) NXTClosed:(NXT*)nxt
{
    [connectMessage setStringValue:[NSString stringWithFormat:@"Disconnected"]];
    [connectButton setEnabled:YES];
    
    [self enableControls:NO];
}


// NXT delegate methods
- (void) NXTError:(NXT*)nxt code:(int)code
{
    [connectMessage setIntValue:code];
}


// handle errors, special case ls pending communication
- (void)NXTOperationError:(NXT*)nxt operation:(UInt8)operation status:(UInt8)status
{
    // if communication is pending on the LS port, just keep polling
	if ( operation == kNXTLSGetStatus && status == kNXTPendingCommunication )
		[nxt LSGetStatus:kNXTSensor4];
	//else
	//	NSLog(@"nxt error: operation=0x%x status=0x%x", operation, status);
}


// if bytes are ready to read, read 'em
- (void) NXTLSGetStatus:(NXT *)nxt port:(UInt8)port bytesReady:(UInt8)bytesReady
{
    //NSLog(@"bytes ready on port %d: %d", port, bytesReady);
	
    // XXX: problem here
	if ( bytesReady > 0 )
		[nxt LSRead:port];
}


// read battery level
- (void)NXTBatteryLevel:(NXT*)nxt batteryLevel:(UInt16)batteryLevel
{
    [batteryLevelIndicator setIntValue:batteryLevel];
}



// read sensor values
- (void)NXTGetInputValues:(NXT*)nxt port:(UInt8)port isCalibrated:(BOOL)isCalibrated type:(UInt8)type mode:(UInt8)mode
				 rawValue:(UInt16)rawValue normalizedValue:(UInt16)normalizedValue
			  scaledValue:(SInt16)scaledValue calibratedValue:(SInt16)calibratedValue
{
    NSString *value = [NSString stringWithFormat:@"%d", scaledValue];
    
    switch ( port )
    {
        case kNXTSensor1:
            [_nxt setLeftTouch:[value integerValue]];
            break;
        case kNXTSensor2:
            [_nxt setRightTouch:[value integerValue]];
            break;
        case kNXTSensor3:
            [_nxt setPrevLightValue:[_nxt lightValue]];
            [_nxt setLightValue:[value integerValue]];
            
            int diff = ([_nxt lightValue] - [_nxt prevLightValue]);
            if(diff > 20){
                NSLog(@"Cycles Complete: %ld",(long)[_nxt numOfCycles]);
                [_nxt setNumOfCycles:[_nxt numOfCycles] + 1];
            }
            break;
    }
    
    [self setSensorTextField:port value:value];
}

// read servo values
- (void) NXTGetOutputState:(NXT *)nxt
                      port:(UInt8)port
                     power:(SInt8)power
                      mode:(UInt8)mode
            regulationMode:(UInt8)regulationMode
                 turnRatio:(SInt8)turnRatio
                  runState:(UInt8)runState
                tachoLimit:(UInt32)tachoLimit
                tachoCount:(SInt32)tachoCount
           blockTachoCount:(SInt32)blockTachoCount
             rotationCount:(SInt32)rotationCount
{
    NSString *value = [NSString stringWithFormat:@"%d", blockTachoCount];
    
//    switch ( port )
//    {
//        case kNXTMotorA:
//            [servoPositionA setStringValue:value];
//            [_nxt setMotorValue:[value integerValue]];
//            break;
//    }
    
}

@end
