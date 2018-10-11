#import "DDYCountryCodeVC.h"
#import "UITableView+DDYIndexView.h"
#import "NSArray+DDYExtension.h"

static NSString *cellID = @"DDYCountryCodeVCCellID";

@interface DDYCountryCodeModel : NSObject
/** 国家或地区简写 */
@property (nonatomic, strong) NSString *countryKey;
/** 区号 */
@property (nonatomic, strong) NSString *countryCode;
/** 国家或地区名称 */
@property (nonatomic, strong) NSString *countryName;
/** 拉丁名称 */
@property (nonatomic, strong) NSString *countryLatin;

+ (NSArray <DDYCountryCodeModel *>*)countryModelArray;

@end

@implementation DDYCountryCodeModel

// [NSLocale ISOCountryCodes], 如果变动需自行修改
+ (void)prepareData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DDYCountryCode" ofType:@"plist"];
        NSArray *countryArray = [NSArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *tempDict in countryArray) {
            NSMutableDictionary *countryDict = [NSMutableDictionary dictionary];
            countryDict[@"countryKey"] = tempDict[@"countryKey"];
            countryDict[@"countryCode"] = tempDict[@"countryCode"];
            countryDict[@"countryName"] = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:tempDict[@"countryKey"]];
            countryDict[@"countryLatin"] = [self latinize:countryDict[@"countryKey"]];
            // 爱国从代码开始
            if ([countryDict[@"countryKey"] isEqualToString:@"TW"]) {
                NSString *TaiWanStr = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"TW"];
                NSString *ChinaStr = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"CN"];
                countryDict[@"countryName"] = [NSString stringWithFormat:@"%@ (%@)", TaiWanStr, ChinaStr];
            }
            [tempArray addObject:countryDict];
        }
        [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"DDYCountryCode"];
    });
}

+ (NSArray<DDYCountryCodeModel *> *)countryModelArray {
    NSArray *countryArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDYCountryCode"];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *countryDict in countryArray) {
        DDYCountryCodeModel *tempMoel = [[DDYCountryCodeModel alloc] init];
        tempMoel.countryKey = countryDict[@"countryKey"];
        tempMoel.countryCode = countryDict[@"countryCode"];
        tempMoel.countryName = countryDict[@"countryName"];
        tempMoel.countryLatin = countryDict[@"countryLatin"];
        [modelArray addObject:tempMoel];
    }
    return modelArray;
}

+ (NSString*)latinize:(NSString*)str {
    NSMutableString *source = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

@end

@interface DDYCountryCodeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 排序后的模型数组 */
@property (nonatomic, strong) NSMutableArray <NSArray *>*modelsArray;
/** 分组标题数组 */
@property (nonatomic, strong) NSMutableArray <NSString *>*titlesArray;

@end

@implementation DDYCountryCodeVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.ddy_IndexViewConfig = [DDYIndexViewConfig configWithIndexViewStyle:DDYIndexViewStyleCenter];
        _tableView.ddy_NavigationBarTranslucent = YES;
    }
    return _tableView;
}

- (NSMutableArray<NSArray *> *)modelsArray {
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}

- (NSMutableArray<NSString *> *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    [self loadCountryData];
}

#pragma mark - 分组
#pragma mark 分组数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titlesArray.count;
}
#pragma mark 分组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titlesArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.modelsArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDYCountryCodeModel *model = self.modelsArray[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    cell.textLabel.text = model.countryName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithRed:80./255. green:80./255. blue:80./255. alpha:1];
    cell.detailTextLabel.text = model.countryCode;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDYCountryCodeModel *model = self.modelsArray[indexPath.section][indexPath.row];
    if (self.countryBlock) {
        self.countryBlock(model.countryCode, model.countryKey, model.countryName, model.countryLatin);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0; //0对应15，1对应25，2对应35，3对应45
}

- (void)loadCountryData {
    // 这里只是基本演示，具体优化啥的自己酌情考虑
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 原始数据
        NSArray *originalArray = [DDYCountryCodeModel countryModelArray];
        // 模型排序(可以用latin只字母, 可以用countryName形式加上配置国际化,)
        [originalArray ddy_ModelSortSelector:@selector(countryName) complete:^(NSArray *modelsArray, NSArray *titlesArray) {
            self.modelsArray = [NSMutableArray arrayWithArray:modelsArray];
            self.titlesArray = [NSMutableArray arrayWithArray:titlesArray];
            self.tableView.ddy_IndexViewDataSource = titlesArray.copy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
}

+ (void)prepareData {
    [DDYCountryCodeModel prepareData];
}

@end

/** 跟随系统 */
