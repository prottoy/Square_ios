//
//  CheckInViewController.m
//  Square
//
//  Created by Mahbub Morshed on 1/23/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "CheckInViewController.h"
#import "SVProgressHUD.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController
@synthesize squareView, segments;


- (void)load_square {
    //Square page load
    NSString *squareUrl= @"http://www.green-red.com/square/";
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:squareUrl]];
    [squareView loadRequest:urlRequest];
}

- (void) receiveSetSegmentNotification:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"setSegment"]){
        [segments setSelectedSegmentIndex:0];
        [segments addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self load_square];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveSetSegmentNotification:)
                                                 name:@"setSegment"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSegment" object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)checkin:(NSString *)emailString nameString:(NSString *)nameString {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:15 green:158 blue:88 alpha:1]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"gnrsqr.png"]];
    
    if (nameString.length>0  && emailString.length>0) {
        //Check-in
        NSString *url= @"http://www.green-red.com/square/checkin/";
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        
        NSString *myreqstr=[NSString stringWithFormat:@"name=%@&email=%@", nameString, emailString];
        
        NSData *myreqdata=[NSData dataWithBytes:[myreqstr UTF8String] length:[myreqstr length]];
        [req setHTTPMethod:@"POST"];
        
        [ req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [ req setHTTPBody: myreqdata ];
        
        NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
        NSLog(@"%@",data);
        NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        NSData *jsondata = [returnstring dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsondata options:0 error:nil];
        
        NSString *responseString= [json objectForKey:@"response"];
        
        if ([responseString isEqualToString:@"invalid email!"]) {
        }
        
        if ([responseString isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:responseString];
        }else{
            [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:15 green:158 blue:88 alpha:1]];
            [SVProgressHUD showErrorWithStatus:responseString];
        }
        
        [self load_square];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Please set your name and email first."];
        [self changeView:nil];
    }
}

-(IBAction)changeView:(id)sender{
    [self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            break;
        case 1:
            [self changeView:nil];
            break;
    }
}

-(IBAction)checkInAction:(id)sender{
    [SVProgressHUD show];
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *nameString=[prefs objectForKey:@"name"];
    NSString *emailString=[prefs objectForKey:@"email"];
    
    [self checkin:emailString nameString:nameString];
}

@end
