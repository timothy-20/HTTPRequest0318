//
//  ViewController.m
//  HTTPRequest0318
//
//  Created by 임정운 on 2021/03/18.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UILabel *serverResponse;

-(void)sendDataToServer:(NSString *)method;

@end

@implementation ViewController
{
    NSMutableData *mutableData;
    
#define URL @"http://127.0.0.1:8080/"
#define NO_CONNECTION @"no connection"
#define NO_VALUES @"please enter parameter values"
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)sendDataGET:(id)sender
{
    [self sendDataToServer:@"GET"];
}

-(IBAction)sendDataPOST:(id)sender
{
    [self sendDataToServer:@"POST"];
}

-(void)sendDataToServer:(NSString *)method
{
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    NSLog(@"%@ %@", username, password);
    
    if(username.length > 0 && password.length > 0) {
        self.serverResponse.text = @"getting response from server";
        
        if([method isEqualToString:@"GET"]) {
            NSString *getURL = [NSString stringWithFormat:@"%@?username=%@&password=%@",URL,username,password];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:[NSURL URLWithString:getURL]];
            [request setHTTPMethod:@"GET"];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (data != nil) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
                    
                    NSLog(@"username: %@", [json objectForKey:@"username"]);
                    NSLog(@"password: %@", [json objectForKey:@"password"]);
                } else {
                    NSLog(@"error");
                }
            }] resume];
        } else {
            NSURLSessionConfiguration *defaultSesstionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSesstionConfiguration];
            
            NSURL *url = url = [NSURL URLWithString:URL];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            
            NSString *postParams = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
            NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
            
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:postData];
            
            NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(data != nil) {
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    NSLog(@"username: %@", [jsonDic objectForKey:@"username"]);
                    NSLog(@"password: %@", [jsonDic objectForKey:@"password"]);
                } else {
                    NSLog(@"error");
                }
            }];
            
            [dataTask resume];
            //resume은 작업이 일시중지 되었을 때, 해당 함수가 걸린 부분부터 재시작 함을 정의할 때 사용한다고 한다. 일단 일시정지 정도의 의미를 가지고 있음.
        }
    } else {
        self.serverResponse.text = NO_VALUES;
    }
}

@end
