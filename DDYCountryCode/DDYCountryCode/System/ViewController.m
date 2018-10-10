#import "ViewController.h"
#import "DDYCountryCodeVC.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

@interface ViewController ()

@property (nonatomic, strong) UILabel *countryLabel;

@end

@implementation ViewController

- (UILabel *)countryLabel {
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _countryLabel.textColor = [UIColor lightGrayColor];
        _countryLabel.text = @"请选择国家";
        _countryLabel.textAlignment = NSTextAlignmentCenter;
        _countryLabel.font = [UIFont systemFontOfSize:16];
        _countryLabel.numberOfLines = 0;
    }
    return _countryLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[self rightBar]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.countryLabel];
}

- (UIBarButtonItem *)rightBar {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(handleSelect)];
}

- (void)handleSelect {
    DDYCountryCodeVC *vc = [[DDYCountryCodeVC alloc] init];
    [vc setCountryBlock:^(DDYCountryCodeModel *countryModel) {
        self.countryLabel.text = [NSString stringWithFormat:@"选择的国家:%@ 简称:%@ 区号:%@", countryModel.countryName, countryModel.country, countryModel.code];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
