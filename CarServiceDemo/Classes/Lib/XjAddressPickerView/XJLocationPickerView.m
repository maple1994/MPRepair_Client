
//
//  XJLocationPickerView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "XJLocationPickerView.h"
#import "AddressInfoModel.h"

@interface XJLocationPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *pickBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
/** 当前省数组 */
@property (strong, nonatomic) NSMutableArray *provinceArray;
/** 当前城市数组 */
@property (strong, nonatomic) NSArray *cityArray;
/** 当前地区数组 */
@property (strong, nonatomic) NSArray *townArray;
/** 当前选中数组 */
@property (strong, nonatomic) NSMutableArray *selectedArray;
/** 选择器 */
@property (nonatomic, strong, nullable)UIPickerView *pickerView;

@property (copy, nonatomic) NSString *nowSelectAddress;

@end

@implementation XJLocationPickerView

- (instancetype)initWithSlectedLocation:(SelectedLocation)selectedLocation
{
    self = [self init];
    self.selectedLocation = selectedLocation;
    return self;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        [self setupUI];
        [self loadData];
    }
    return self;
}


- (void)setupUI
{
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    [self.layer setOpaque:0.0];
    [self.pickBackView addSubview:self.pickerView];
    _backView.cornerRadius = 10;
    kWeakSelf(weakSelf)
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.pickBackView);
    }];
}

- (void)loadData
{
    [self getAddressInfo];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
    
        AddressInfoModel *pModel = self.provinceArray[row];
        self.cityArray = pModel.children;
        AddressInfoModel *cModel = [self.cityArray firstObject];
        self.townArray = cModel.children;
    
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        AddressInfoModel *cModel = self.cityArray[row];
        self.townArray = cModel.children;
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
    
    [self reloadata];
    
}

//自定义pcierview显示
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        
        AddressInfoModel *pModel = self.provinceArray[row];
        text = pModel.name;
        
    }else if (component == 1){
        
        AddressInfoModel *cModel = self.cityArray[row];
        text = cModel.name;
        
    }else{
        if (self.townArray.count > 0) {
            AddressInfoModel *tModel = self.townArray[row];
            text = tModel.name;
            
        }else{
            text =  @"";
        }
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}

//选择的数组
- (void)reloadata;
{
    AddressInfoModel *province = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    AddressInfoModel *city = [self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    AddressInfoModel *town;
    if (self.townArray.count != 0) {
        
        town = [self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
        
    }
    
    self.nowSelectAddress = [[province.name stringByAppendingString:[NSString stringWithFormat:@"  %@", city.name]] stringByAppendingString:[NSString stringWithFormat:@"  %@", town.name]];
}

- (IBAction)affirmButtonAction:(id)sender {
    
    AddressInfoModel *province = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    AddressInfoModel *city = [self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    AddressInfoModel *town;
    if (self.townArray.count != 0) {
        
        town = [self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
        
    }
    if(province && city && town){
        self.selectedLocation(@[province.ID, city.ID, town.ID],self.nowSelectAddress);
    }
    
    [self remove];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self remove];
}

-(void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.bottomConstraint.constant = 10;
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(kMAIN_WINDOW);
    }];
}

- (void)remove
{
    [UIView animateWithDuration:.3 animations:^{
        self.bottomConstraint.constant = -self.height;
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)getAddressInfo{

    NSFileManager *fm = [NSFileManager defaultManager];//拿本地的
    NSData *fileData = [fm contentsAtPath:[kDownloadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"AddressInfo.json"]]];
    if (fileData) {

        NSError *error;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:&error];

        for (NSDictionary *dict in arr) {
            
            AddressInfoModel *model = [[AddressInfoModel alloc] initWithDictionary:dict error:nil];

            [self.provinceArray addObject:model];
            
        }
        
        AddressInfoModel *pModel = [self.provinceArray firstObject];
        
        self.cityArray = pModel.children;
        
        AddressInfoModel *cModel = [self.cityArray firstObject];
        self.townArray = cModel.children;
        
        [self.pickerView reloadAllComponents];
        
    }else{
        [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];

        kWeakSelf(weakSelf)

        [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/addressinfo/" parameters:nil result:^(id obj, int status, NSString *msg) {
            
            if (status == 1) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
                
                NSData *saveData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
                if([saveData writeToFile:[kDownloadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"AddressInfo.json"]] atomically:YES]){
                    NSLog(@"地址json数据保存成功");
                }else{
                    NSLog(@"地址json数据保存失败");
                }
                
                [weakSelf getAddressInfo];

            }else{
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            }

        }];
    }
}

//- (void)getAddressInfo{
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
//    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
//    self.provinceArray = [self.pickerDic allKeys];
//    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
//
//    if (self.selectedArray.count > 0) {
//        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
//    }
//
//    if (self.cityArray.count > 0) {
//        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
//    }
//
//}

#pragma mark - 懒加载
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, _pickBackView.width, _pickBackView.height)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (NSArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}

- (NSArray *)townArray{
    if (!_townArray) {
        _townArray = [NSArray array];
    }
    return _townArray;
}

@end
