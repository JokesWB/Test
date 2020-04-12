//
//  ViewController.m
//  Test
//
//  Created by 刘广 on 2020/4/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import "LLNetworkManagerTool.h"
#import <Toast.h>
#import "TestViewCell.h"
#import <YYModel.h>
#import "TestModel.h"
#import <MJRefresh.h>

static NSString *cellID = @"cell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    dispatch_queue_t queue;
    dispatch_group_t group;
    dispatch_semaphore_t semaphore;
}

@property (nonatomic, assign) int count;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) int direction;
@property (nonatomic, assign) long lastItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addContentAction)];
    
    queue = dispatch_queue_create("com.lg.www", DISPATCH_QUEUE_SERIAL);
    
    group = dispatch_group_create();
    
    semaphore = dispatch_semaphore_create(0);
    
    self.isFirst = YES;
    [self getJsonDatas];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.direction = 1;
        self.isFirst = YES;
        [self getJsonDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.direction = 0;
        self.isFirst = YES;
        [self getJsonDatas];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}




- (void)addContentAction
{
    self.isFirst = NO;
    self.count++;
    
    dispatch_group_async(group, queue, ^{
        
        [self postJsonDatas];
        
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);
        
    });
    
    
    
    dispatch_group_async(group, queue, ^{
        
        [self getJsonDatas];
        
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);
        
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"请求结束");
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        });
        
    });
}

- (void)postJsonDatas
{
    NSString *contentStr = [NSString stringWithFormat:@"这是一个测试_%d", self.count];
    NSString *urlStr = @"https://3evjrl4n5d.execute-api.us-west-1.amazonaws.com/dev/message";
    NSDictionary *dic = @{
        @"id" : @"lg_test",
        @"content" : contentStr,
    };
    
    [[LLNetworkManagerTool sharedManager] postJsonWithUrlString:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.view makeToast:@"添加成功"];
        
        dispatch_semaphore_signal(self->semaphore);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
        
        [self.view makeToast:@"添加失败"];
        
        dispatch_semaphore_signal(self->semaphore);
        
    } showLoadingInView:[UIApplication sharedApplication].keyWindow];
}

- (void)getJsonDatas
{
    NSString *urlStr = @"https://3evjrl4n5d.execute-api.us-west-1.amazonaws.com/dev/message";

    NSMutableDictionary *dic = @{
        @"id" : @"lg_test",
        @"limit" : @3,
    }.mutableCopy;
    
    if (self.lastItem > 0) {
        [dic setObject:@(self.lastItem) forKey:@"lastItem"];
        [dic setObject:@(self.direction) forKey:@"direction"];
    }
    [[LLNetworkManagerTool sharedManager] requestMethod:GET urlString:urlStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取数据 >> %@", responseObject);
        
        if (self.direction == 1) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *arr = responseObject[@"data"][@"items"];
        for (NSDictionary *dic in arr) {
            TestModel *model = [TestModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        
        TestModel *m = self.dataArray.lastObject;
        self.lastItem = m.creationTime;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.isFirst) {
            [self.tableView reloadData];
        } else {
            dispatch_semaphore_signal(self->semaphore);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (!self.isFirst) {
            dispatch_semaphore_signal(self->semaphore);
        }
    } showLoadingInView:[UIApplication sharedApplication].keyWindow];
}





- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
