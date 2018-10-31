//
//  ViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/25.
//  Copyright © 2018 whs. All rights reserved.
//

#import "ViewController.h"
#import "FunViewController.h"
#import "WKViewController.h"
#import "WK02ViewController.h"
#import "WK03ViewController.h"
#import "WebViewController.h"
#import "WebView02Controller.h"
#import "WebView03Controller.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSArray *dataArrs;
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArrs = @[@"objc_msgSend发送消息", @"Runtime交换方法实现", @"动态添加方法",
                  @"runtime取类的一些信息", @"关联对象给分类增加属性", @"KVC", @"KVO",
                  @"Block介绍", @"WKWebView-协议拦截",@"WKWebView-WKScriptMessageHandler协议",
                  @"WKWebView-WKUIDelegate协议",
                  @"UIWebView-协议拦截",
                  @"UIWebView-JavaScriptCore框架",
                  @"UIWebView-JSExport协议"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArrs[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 8) {
        WKViewController *wkVC = [[WKViewController alloc]init];
        [self.navigationController pushViewController:wkVC animated:YES];
        return;
    }else if (indexPath.row == 9){
        WK02ViewController *wk02VC = [[WK02ViewController alloc]init];
        [self.navigationController pushViewController:wk02VC animated:YES];
        return;
        
    }else if (indexPath.row == 10){
        WK03ViewController *wk03VC = [[WK03ViewController alloc]init];
        [self.navigationController pushViewController:wk03VC animated:YES];
        return;
    }else if (indexPath.row == 11){
        WebViewController *webVC = [[WebViewController alloc]init];
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }else if (indexPath.row == 12){
        WebView02Controller *web02VC = [[WebView02Controller alloc]init];
        [self.navigationController pushViewController:web02VC animated:YES];
        return;
    }else if (indexPath.row == 13){
        WebView03Controller *web03VC = [[WebView03Controller alloc]init];
        [self.navigationController pushViewController:web03VC animated:YES];
        return;
    }
    
    
    FunViewController *funVC = [[FunViewController alloc]init];
    funVC.atIndex = indexPath.row;
    [self.navigationController pushViewController:funVC animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
