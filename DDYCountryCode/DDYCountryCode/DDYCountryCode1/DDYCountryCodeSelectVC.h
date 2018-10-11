#import <UIKit/UIKit.h>

@interface DDYCountryCodeSelectVC : UIViewController

@property (nonatomic, copy) void (^countryBlock)(NSString *countryCode, NSString *countryKey, NSString *countryName, NSString *countryLatin);

@end
