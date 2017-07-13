//
//  ViewController.m
//  cdlogtest


//

#import "ViewController.h"
#import "CRMLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CRMLog outPutLog:@"描述" content: @"内容"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
