//
//  RegisterViewController.m
//  Leisure
//
//  Created by 左建军 on 16/4/7.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoManager.h"

@interface RegisterViewController ()

@property (nonatomic, assign) NSInteger gender;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *femailButton;

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

// 返回按钮
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 选择男
- (IBAction)mailButton:(id)sender {
    _gender = 0;
    [_mailButton setBackgroundColor:[UIColor blueColor]];
    [_femailButton setBackgroundColor:[UIColor lightGrayColor]];
}
// 选择女
- (IBAction)feMailButton:(id)sender {
    _gender = 1;
    [_femailButton setBackgroundColor:[UIColor blueColor]];
    [_mailButton setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 默认性别初始为男
    _gender = 0;
    [_mailButton setBackgroundColor:[UIColor blueColor]];
    // 设置圆角
    _mailButton.layer.cornerRadius = 10;
    _femailButton.layer.cornerRadius = 10;
}
// 注册按钮
- (IBAction)registButton:(id)sender {
    [NetWorkrequestManage requestWithType:POST url:REGIST_URL parameters:@{@"email" : _emailTextField.text, @"gender" : [NSNumber numberWithInteger:_gender], @"passwd" : _passwdTextField.text, @"uname" : [_nickNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dataDic = %@", dataDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *result = [dataDic objectForKey:@"result"];
            
            //注册失败
            if ([result intValue] == 0) {
                NSLog(@"msg = %@", [[dataDic objectForKey:@"data"] objectForKey:@"msg"]);
                NSString *message = [[dataDic objectForKey:@"data"] objectForKey:@"msg"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
            } else { //注册成功
                NSLog(@"data = %@", [dataDic objectForKey:@"data"]);
                //保存用户的auth
                [UserInfoManager conserveUserAuth:[[dataDic objectForKey:@"data"] objectForKey:@"auth"]];
                //保存用户名
                [UserInfoManager conserveUserName:[[dataDic objectForKey:@"data"] objectForKey:@"uname"]];
                //保存用户id
                [UserInfoManager conserveUserID:[[dataDic objectForKey:@"data"] objectForKey:@"uid"]];
                //保存用户icon
                [UserInfoManager conserveUserIcon:[[dataDic objectForKey:@"data"] objectForKey:@"icon"]];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
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
