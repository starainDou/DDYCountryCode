#import "ViewController.h"
#import "DDYCountryCodeVC.h"
#import "DDYCountryCodeSelectVC.h"
#import "DDYLanguageSelectVC.h"

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

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;

@end

@implementation ViewController

- (UIButton *)btnY:(CGFloat)y tag:(NSUInteger)tag title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setFrame:CGRectMake(10, DDYTopH + y, DDYScreenW-20, 40)];
    [button setTag:tag];
    [button addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [self btnY: 50 tag:100 title:@"国际区号选择(跟随系统国际化)"];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [self btnY:200 tag:101 title:@"国际区号选择(应用内国际化)"];
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        NSString *language = NSLocalizedStringFromTable(@"DDYCurrentLanguage", @"DDYCountry", nil);
        _button3 = [self btnY:250 tag:102 title:[NSString stringWithFormat:@"应用内语言切换 当前语言:%@", language]];
    }
    return _button3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [DDYCountryCodeVC prepareData];
}

- (void)handleBtn:(UIButton *)sender {
    if (sender.tag == 100) {
        [self countryCodeSelectWithSystem];
    } else if (sender.tag == 101) {
        [self countryCodeSelectWithApp];
    } else if (sender.tag == 102) {
        [self changeLanguage];
    }
}

- (void)countryCodeSelectWithSystem {
    DDYCountryCodeVC *vc = [[DDYCountryCodeVC alloc] init];
    [vc setCountryBlock:^(NSString *countryCode, NSString *countrykey, NSString *countryName, NSString *countryLatin) {
        NSString *title = [NSString stringWithFormat:@"选择的国家:%@ 简称:%@ 区号:%@", countryName, countrykey, countryCode];
        [self.button1 setTitle:title forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)countryCodeSelectWithApp {
    DDYCountryCodeSelectVC *vc = [[DDYCountryCodeSelectVC alloc] init];
    [vc setCountryBlock:^(NSString *countryCode, NSString *countrykey, NSString *countryName, NSString *countryLatin) {
        NSString *title = [NSString stringWithFormat:@"选择的国家:%@ 简称:%@ 区号:%@", countryName, countrykey, countryCode];
        [self.button2 setTitle:title forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeLanguage {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[DDYLanguageSelectVC alloc] init]];
    [self presentViewController:navi animated:YES completion:^{ }];
}

@end
