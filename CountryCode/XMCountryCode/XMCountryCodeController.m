//
//  XMCountryCodeController.m
//  SmartWatch
//
//  Created by 王续敏 on 2017/6/16.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import "XMCountryCodeController.h"


@interface XMCountryCodeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UIScrollViewDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , strong) NSMutableArray *searchResultArray;//搜索结果数据
@property (nonatomic , strong) NSMutableArray *allKeys;
@property (nonatomic , strong) UISearchController *searchController;
@property (nonatomic , strong) NSDictionary *sourceDic;
@property (nonatomic , copy) CountryCodeBlock codeBlock;
@property (nonatomic , strong) UITableView *resultTableView;
@end

@implementation XMCountryCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    self.searchResultArray = [NSMutableArray array];
    self.allKeys = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.keyboardType = UIKeyboardAppearanceDefault;
    self.searchController.searchBar.placeholder = @"搜索";
    
    self.resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _searchController.view.bounds.size.width, _searchController.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.searchController.view addSubview:_resultTableView];
    
    NSString *dataSourcePath = [[NSBundle mainBundle] pathForResource:@"CountryCodes" ofType:@"plist"];
    self.sourceDic = [NSDictionary dictionaryWithContentsOfFile:dataSourcePath];
    self.allKeys = [_sourceDic allKeys].mutableCopy;
    [self.allKeys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 > obj2;
    }];
    [self.tableView reloadData];
    typeof(self) weakSelf = self;
    [self.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.dataSource addObjectsFromArray:_sourceDic[key]];
    }];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 15, 20);
    [leftButton setImage:[UIImage imageNamed:@"codeBack"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"选择国家和地区";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor darkGrayColor]];
}

- (void)dismissAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _resultTableView) {
        return 1;
    }else{
        return self.allKeys.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _resultTableView) {
        return self.searchResultArray.count;
    }else{
        return [self.sourceDic[self.allKeys[section]] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
    }
    NSString *string = nil;
    if (tableView == _tableView) {
        string = [self.sourceDic objectForKey:self.allKeys[indexPath.section]][ indexPath.row];
    }else{
        if (self.searchResultArray.count > 0) {
            string = self.searchResultArray[indexPath.row];
        }
    }
    if ([string containsString:@"+"]) {
        NSArray *titles = [string componentsSeparatedByString:@"+"];
        cell.textLabel.text = titles.firstObject;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",titles.lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.codeBlock) {
        self.codeBlock(cell.textLabel.text, cell.detailTextLabel.text);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return self.allKeys;
    }else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return self.allKeys[section];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _resultTableView) {
        return 0.001;
    }else{
        return tableView.sectionFooterHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _resultTableView) {
        return 0.001;
    }else{
        return tableView.sectionHeaderHeight;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchText];
    self.searchResultArray = [NSMutableArray arrayWithArray:[_dataSource filteredArrayUsingPredicate:predicate]];
    [self.resultTableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (!searchController.active) {
        [self.searchResultArray removeAllObjects];
        [self.resultTableView reloadData];
    }
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)countryCode:(CountryCodeBlock)block{
    self.codeBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
