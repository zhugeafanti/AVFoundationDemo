//
//  ScanCodeViewController.h
//  AVFoundationDemo
//
//  Created by 刘瑞刚 on 15/11/19.
//  Copyright © 2015年 刘瑞刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeViewController : UIViewController
@property (copy, nonatomic) void(^sucessScanBlock)(NSString *result);
@end
