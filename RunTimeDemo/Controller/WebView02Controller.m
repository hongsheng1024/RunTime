//
//  WebViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/30.
//  Copyright © 2018 whs. All rights reserved.
//

#import "WebView02Controller.h"
#import "UIViewExt.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebView02Controller ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView;

@end

@implementation WebView02Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"WebView";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MAINSCREENWIDTH, 200)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test02" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    UIButton *loginBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn01.frame = CGRectMake(20, _webView.bottom + 30, 120, 40);
    [loginBtn01 setBackgroundColor:[UIColor grayColor]];
    [loginBtn01 setTitle:@"OC调用JS01" forState:UIControlStateNormal];
    [loginBtn01 addTarget:self action:@selector(loginBtn01Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn01];
    
    UIButton *alertMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    alertMobile.frame = CGRectMake(20, loginBtn01.bottom + 10, 120, 40);
    [alertMobile setBackgroundColor:[UIColor grayColor]];
    alertMobile.tag = 123;
    [alertMobile setTitle:@"alertMobile" forState:UIControlStateNormal];
    [alertMobile addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertMobile];
    
    UIButton *alertName = [UIButton buttonWithType:UIButtonTypeCustom];
    alertName.frame = CGRectMake(20, alertMobile.bottom + 10, 120, 40);
    [alertName setBackgroundColor:[UIColor grayColor]];
    alertName.tag = 234;
    [alertName setTitle:@"alertName" forState:UIControlStateNormal];
    [alertName addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertName];
    
    UIButton *alertSendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    alertSendMsg.frame = CGRectMake(20, alertName.bottom + 10, 120, 40);
    [alertSendMsg setBackgroundColor:[UIColor grayColor]];
    alertSendMsg.tag = 345;
    [alertSendMsg setTitle:@"alertSendMsg" forState:UIControlStateNormal];
    [alertSendMsg addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertSendMsg];
    
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

//UIWebView在每次加载请求完成后会调用此方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //获取JS代码的执行环境/上下文/作用域
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //监听JS代码里面的方法（执行效果上可以理解成重写了JS的方法）
    context[@"jsToOc"] = ^(NSString *action, NSString *param){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:action message:param delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        });
    };
    
    context[@"btnClick1"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"showMobile" message:@"showMobile" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        });
    };
    
//    context[@"showName"] = ^(NSString *name){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"showName" message:name delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        });
//    };
    
    void(^showName)(NSString *name) = ^(NSString *name){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"showName" message:name delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
    };
    [context setObject:showName forKeyedSubscript:@"showName"];
    
    
    
    context[@"showSendMsg"] = ^(NSString *phone, NSString *msg){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:phone message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        });
    };
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - Action
- (void)loginBtn01Action:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        [context evaluateScript:[NSString stringWithFormat:@"ocToJs('loginSucceed', 'oc_tokenString')"]];
        
    });
}

- (void)btnAction:(UIButton *)sender{
    if (sender.tag == 123) {
        //[self.webView stringByEvaluatingJavaScriptFromString:@"alertMobile()"];
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:[NSString stringWithFormat:@"alertMobile()"]];
        
    }
    
    if (sender.tag == 234) {
        //[self.webView stringByEvaluatingJavaScriptFromString:@"alertName('小红')"];
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:[NSString stringWithFormat:@"alertName('小红')"]];
    }
    
    if (sender.tag == 345) {
        //[self.webView stringByEvaluatingJavaScriptFromString:@"alertSendMsg('18870707070','周末爬山真是件愉快的事情')"];
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:[NSString stringWithFormat:@"alertSendMsg('18870707070','周末爬山真是件愉快的事情')"]];
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

