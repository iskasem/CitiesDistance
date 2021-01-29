//
//  ViewController.m
//  DistanceLocation_PeerReview004
//
//  Created by Islam Kasem on 27/01/2021.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *Req ;
@property (weak, nonatomic) IBOutlet UITextField *startocationTxt;
@property (weak, nonatomic) IBOutlet UITextField *endLocationATxt;
@property (weak, nonatomic) IBOutlet UITextField *endLocationBTxt;
@property (weak, nonatomic) IBOutlet UITextField *endLocationCTxt;
@property (weak, nonatomic) IBOutlet UILabel *distancALbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceBLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceCLbl;
@property (weak, nonatomic) IBOutlet UIButton *calculateBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ViewController


- (IBAction)calcBtnPressed:(id)sender {
    self.calculateBtn.enabled = NO ;
    self.Req = [DGDistanceRequest alloc];
    NSString *startLocation = self.startocationTxt.text;
    NSString *destA = self.endLocationATxt.text;
    NSString *destB = self.endLocationBTxt.text;
    NSString *destC = self.endLocationCTxt.text;
    NSArray *stats = @[destA, destB , destC];
    
    self.Req = [self.Req initWithLocationDescriptions:stats sourceDescription:startLocation];
    
    
    __weak ViewController *weakSelf = self;
    
    self.Req.callback = ^void(NSArray *responses){
        ViewController *strongSelf = weakSelf;
        if(!strongSelf) return;
        NSNull *badResult = [NSNull null];
        
        //looping within the array of the response
        
        for (int i = 0 ;i < [responses count] ; i++){
            
        
        if (responses[i] != badResult ) {
            //meters
            double  num = ([responses[i] floatValue ]);
            NSString *x = [NSString stringWithFormat:@"%.2f m" ,num ];
            
            if (self.segmentControl.selectedSegmentIndex == 0){
                //kilometers
                num = ([responses[i] floatValue ]/1000.0);
                x = [NSString stringWithFormat:@"%.2f km" ,num ];
                
            }else if (self.segmentControl.selectedSegmentIndex == 1){
                //miles
                num = ([responses[i] floatValue ]/1609.34);
                x = [NSString stringWithFormat:@"%.2f Mile" ,num ];
            }
            if (i == 0){
                strongSelf.distancALbl.text = x ;
            }else if (i == 1){
                strongSelf.distanceBLbl.text = x ;
            } else{
                strongSelf.distanceCLbl.text = x;
            }
          
        }else {
            if (i == 0){
                strongSelf.distancALbl.text = @"error";
            }else if (i == 1){
                strongSelf.distanceBLbl.text = @"error";
            }else{
                strongSelf.distanceCLbl.text = @"error";
            }
          
        }
        }
        
        
        strongSelf.Req = nil ;
        strongSelf.calculateBtn.enabled = YES;
        strongSelf.Req = nil;
    };
    
    [self.Req start];
    
    
}


@end
