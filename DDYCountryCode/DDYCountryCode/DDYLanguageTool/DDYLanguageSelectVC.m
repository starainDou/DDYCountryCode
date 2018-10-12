#import "DDYLanguageSelectVC.h"
#import "DDYLanguageTool.h"
#import "AppDelegate.h"

@interface DDYLanguageSelectVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DDYLanguageSelectVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableFooterView:[UIView new]];
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddyCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddyCellID"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    NSString *tempTag = self.dataArray[indexPath.row][@"tag"];
    cell.accessoryType = [tempTag isEqualToString:[DDYLanguageTool ddy_AppLanguage]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak __typeof__ (self)weakSelf = self;
    [DDYLanguageTool ddy_SetLanguage:self.dataArray[indexPath.row][@"tag"] complete:^(NSError *error) {
        __strong __typeof__ (weakSelf)strongSelf = weakSelf;
        [strongSelf resetRootViewController];
    }];
}

#pragma mark 重新设置
- (void)resetRootViewController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(@"ViewController") alloc] init]];
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dataArray addObject:@{@"title":@"简体中文", @"tag":DDY_ZHS}];
        [self.dataArray addObject:@{@"title":@"繁體中文", @"tag":DDY_ZHT}];
        [self.dataArray addObject:@{@"title":@"English", @"tag":DDY_EN}];
        [self.dataArray addObject:@{@"title":@"日本語", @"tag":DDY_JA}];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

@end
