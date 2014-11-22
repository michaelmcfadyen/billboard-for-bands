/* $Id: LegoNXTRemote.h 17 2009-02-01 01:18:33Z querry43 $ */

/*! \file LegoNXTRemote.h
* This file describes a graphical interface for the LegoNXT Framework.
*
* \author Matt Harrington
* \date 01/04/09
*/

#import <Cocoa/Cocoa.h>
#import <LegoNXT.h>

@interface LegoNXTRemote : NSObject
{
    NXT *_nxt;
    
    IBOutlet NSLevelIndicator *batteryLevelIndicator;
    IBOutlet NSTextField *connectMessage;
    
    IBOutlet NSButton *connectButton;
    
    IBOutlet NSButton *sensorPoll1;
    IBOutlet NSButton *sensorPoll2;
    
    IBOutlet NSButton *servoPollA;
    IBOutlet NSButton *servoPositionReset;
    
    IBOutlet NSPopUpButton *sensorType1;
    IBOutlet NSPopUpButton *sensorType2;
    
    IBOutlet NSTextField *sensorValue1;
    IBOutlet NSTextField *sensorValue2;
    
    IBOutlet NSTextField *servoPositionA;
    
    BOOL isPollingSensor[4];
    BOOL isPollingServo[3];
}
- (IBAction)doConnect:(id)sender;

- (IBAction)doPollSensor1:(id)sender;
- (IBAction)doPollSensor2:(id)sender;

- (IBAction)doPollServoA:(id)sender;

- (IBAction)doResetServoPosition:(id)sender;
@end
