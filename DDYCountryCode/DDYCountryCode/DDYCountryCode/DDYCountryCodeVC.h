

#import <UIKit/UIKit.h>
#import "DDYCountryCodeModel.h"

@interface DDYCountryCodeVC : UIViewController

@property (nonatomic, copy) void (^countryBlock)(DDYCountryCodeModel *countryModel);

@end
