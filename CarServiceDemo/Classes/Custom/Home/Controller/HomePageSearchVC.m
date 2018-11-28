//
//  HomePageSearchVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "HomePageSearchVC.h"
#import "HomePageSearchCell.h"
#import "ServicePointDetailsVC.h"

@interface HomePageSearchVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLabelCenterX;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectBtns;

/// 数据源
@property (nonatomic ,strong)NSMutableArray *dataArr;

/// 筛选条件
@property (nonatomic ,copy)NSString *orderby;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewBottom;

@end

static NSString *HomePageSearchCellID = @"HomePageSearchCell";

@implementation HomePageSearchVC

#pragma mark -- 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /// 初始化属性
    [self setupProperty];
    
    [self addRefresh];
    
    [self selectBtnsAction:self.selectBtns[0]];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupProperty{
    
//    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
//    //设置背景图片
//    [_searchBar setBackgroundImage:searchBarBg];
//    //设置背景色
//    [_searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
//    [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    _searchBar.tintColor = [UIColor colorwithHexString:@"A3A3A3"];;
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [searchField setValue:[UIColor colorwithHexString:@"A3A3A3"] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont systemFontOfSize:14];
    
    [self.tableView registerNib:[UINib nibWithNibName:HomePageSearchCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HomePageSearchCellID];
    
    if (@available(iOS 11.0, *)) {//防止Y轴偏移64像素
        
    } else {
        self.myContentViewTop.constant = 20;
        self.myContentViewBottom.constant = -54;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)addRefresh{
    
    kWeakSelf(weakSelf);
    
    [TableRefresher refreshTable:self.tableView refreshBlock:^(BOOL refresh) {
        [weakSelf requestRepairShopInfo];
    }];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- 请求维修点信息
- (void)requestRepairShopInfo{
    
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderby"] = self.orderby;
    params[@"longitude"] = self.currentLng;
    params[@"latitude"] = self.currentLat;
    params[@"name"] = self.searchBar.text;

    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    [self.util getDataWithPath:@"/api/maintain/garage/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            if (weakSelf.tableView.page == 1) {
                weakSelf.dataArr = nil;
                
            }
            weakSelf.tableView.page ++;
            
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *modelDict in obj) {
                    RepairShopInfoModel *model =[[RepairShopInfoModel alloc]initWithDictionary:modelDict error:nil];
                    [weakSelf.dataArr addObject:model];
                }
            }
            
            [TableRefresher endRefreshTable:weakSelf.tableView];
            [weakSelf.tableView reloadData];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }else{
            
            [TableRefresher endRefreshTable:weakSelf.tableView];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        return self.tableView.height;
    }
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        QMNoDataTableViewCell *cell = [[QMNoDataTableViewCell alloc]init];
        cell.descStr = @"暂无数据";
        cell.descStrColor = @"#CCCCCC";
        cell.imageName = KDefaultImage;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    HomePageSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageSearchCellID];
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

- (IBAction)selectBtnsAction:(UIButton *)sender {
//    [self.buttomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(sender.center);
//    }];
    self.buttomLabel.centerX = sender.centerX;
    for(UIButton *btn in self.selectBtns){
        if (sender == btn) {
            sender.selected = YES;
        }else{
            btn.selected = NO;
        }
        
    }
    
    switch (sender.tag) {
        case 0:
            self.orderby = @"distance";
            break;
        case 1:
            self.orderby = @"distance";
            break;
        case 2:
            self.orderby = @"popular";
            break;
        default:
            break;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArr.count == 0){
        return;
    }
    
    ServicePointDetailsVC *detailsVC =[[ServicePointDetailsVC alloc]init];
    detailsVC.dataModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (IBAction)popBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
