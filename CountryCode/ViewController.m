//
//  ViewController.m
//  CountryCode
//
//  Created by 王续敏 on 2017/6/16.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import "ViewController.h"
#import "XMCountryCodeController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)selectCode:(UIButton *)sender {
    typeof(self) weakSelf = self;
    XMCountryCodeController *xmCountryCode = [[XMCountryCodeController alloc] init];
    [xmCountryCode countryCode:^(NSString *country, NSString *code) {
        weakSelf.codeLabel.text = [NSString stringWithFormat:@"%@%@",country,code];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xmCountryCode];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
