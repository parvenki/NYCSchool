//
//  Utilities.h
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/20/23.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
@implementation Utilities

+ (UIAlertController *)getAlertController:(NSString *)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                        message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    
    indicator.hidesWhenStopped = YES;
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleMedium];
    
    [indicator startAnimating];
    [[alert view] addSubview: indicator];
    
    return alert;
}
@end
