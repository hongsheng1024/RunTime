//
//  WKViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/30.
//  Copyright © 2018 whs. All rights reserved.
//

#import "WK02ViewController.h"
#import "UIViewExt.h"
#import <WebKit/WebKit.h>


@interface WK02ViewController ()<WKScriptMessageHandler>

@property(nonatomic, strong)WKWebView *wkWebView;

@end

@implementation WK02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"WKWebView";
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //使用WKUserContentController的-addScriptMessageHandler:name:方法监听name为jsToOc的消息；
    [userContentController addScriptMessageHandler:self name:@"jsToOc"];
    [userContentController addScriptMessageHandler:self name:@"showMobile"];
    
    //! 使用添加了ScriptMessageHandler的userContentController配置configuration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    config.userContentController = userContentController;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 300) configuration:config];
    [self.view addSubview:self.wkWebView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test04" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.wkWebView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    
}

#pragma mark - WKScriptMessageHandler
//! WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
{
    if ([message.name caseInsensitiveCompare:@"jsToOc"] == NSOrderedSame) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:message.name message:message.body delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"%@", message.body);
    }else if ([message.name caseInsensitiveCompare:@"showMobile"] == NSOrderedSame){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:message.name message:message.body delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
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

