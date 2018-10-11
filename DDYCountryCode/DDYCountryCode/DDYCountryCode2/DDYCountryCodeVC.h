#import <UIKit/UIKit.h>

@interface DDYCountryCodeVC : UIViewController

@property (nonatomic, copy) void (^countryBlock)(NSString *countryCode, NSString *countryKey, NSString *countryName, NSString *countryLatin);

+ (void)prepareData;

@end
