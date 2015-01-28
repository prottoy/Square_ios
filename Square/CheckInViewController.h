//
//  CheckInViewController.h
//  Square
//
//  Created by Mahbub Morshed on 1/23/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController

@property(nonatomic, strong) IBOutlet UISegmentedControl *segments;
@property(nonatomic, strong) IBOutlet UIWebView *squareView;

-(IBAction)changeView:(id)sender;
@end
