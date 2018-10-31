//
//  WKViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/30.
//  Copyright © 2018 whs. All rights reserved.
//

#import "WKViewController.h"
#import "UIViewExt.h"
#import <WebKit/WebKit.h>


@interface WKViewController ()<WKNavigationDelegate>

@property(nonatomic, strong)WKWebView *wkWebView;

@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"WKWebView";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 300) configuration:config];
    _wkWebView.navigationDelegate = self;
    
    [self.view addSubview:self.wkWebView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.wkWebView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    
    UIButton *loginBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn01.frame = CGRectMake(20, _wkWebView.bottom + 30, 120, 40);
    [loginBtn01 setBackgroundColor:[UIColor grayColor]];
    [loginBtn01 setTitle:@"OC调用JS01" forState:UIControlStateNormal];
    [loginBtn01 addTarget:self action:@selector(loginBtn01Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn01];
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
{
    
}
#pragma mark - WKNavigationDelegate
//WKWeView在每次加载请求前会调用此方法来确认是否进行请求跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *ss = navigationAction.request.URL.scheme;
    if ([navigationAction.request.URL.scheme caseInsensitiveCompare:@"jsToOc"] == NSOrderedSame) {
        decisionHandler(WKNavigationActionPolicyCancel);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:navigationAction.request.URL.host message:navigationAction.request.URL.query delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
         decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//! WKWebView在每次加载请求完成后会调用此方法
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        self.title = title;
    }];
}


#pragma mark - Action
- (void)loginBtn01Action:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:@"ocToJs('loginSucceed', 'oc_tokenString')" completionHandler:^(id response, NSError *error) {}];
    });
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
