//
//  XMCountryCodeController.h
//  SmartWatch
//
//  Created by 王续敏 on 2017/6/16.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountryCodeBlock)(NSString *country,NSString *code);

@interface XMCountryCodeController : UIViewController

- (void)countryCode:(CountryCodeBlock)block;

@end
