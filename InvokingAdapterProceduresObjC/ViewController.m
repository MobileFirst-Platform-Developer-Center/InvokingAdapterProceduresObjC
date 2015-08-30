/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

//
//  ViewController.m
//  nativeIOSApp

#import "ViewController.h"
#import "MyConnectListener.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textView;

- (IBAction)doConnect:(UIButton *)sender {
    [self updateView:@"Initializing..."];
    NSLog(@"Initializing...");
    MyConnectListener *connectListener = [[MyConnectListener alloc] initWithController:self];
    [[WLClient sharedInstance] wlConnectWithDelegate:connectListener];

}

- (IBAction)doInvokeProcedure:(UIButton *)sender {
    [self updateView:@"Invoking Procedure..."];
    NSLog(@"Invoking Procedure...");

    NSURL* url = [NSURL URLWithString:@"/adapters/RSSReader/getFeed"];
    WLResourceRequest* request = [WLResourceRequest requestWithURL:url method:WLHttpMethodGet];

    [request setQueryParameterValue:@"['MobileFirst_Platform']" forName:@"params"];

    [request sendWithCompletionHandler:^(WLResponse *response, NSError *error) {
        NSString* resultText;
        if(error != nil){
            resultText = @"Invocation failure.";
            resultText = [resultText stringByAppendingString: error.description];
        }
        else{
            resultText = @"Invocation success.";
            resultText = [resultText stringByAppendingString:response.responseText];
        }
        [self updateView:resultText];
    }];

}

- (void) updateView:(NSString *)response {
    [textView setText:response];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad called.");
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
