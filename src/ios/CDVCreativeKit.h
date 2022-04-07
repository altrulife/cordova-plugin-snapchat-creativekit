#import <Cordova/CDVPlugin.h>

@interface CDVCreativeKit : CDVPlugin {}

- (void)shareToCameraPreview:(CDVInvokedUrlCommand*)command;
- (void)sharePhoto:(CDVInvokedUrlCommand*)command;

@end
