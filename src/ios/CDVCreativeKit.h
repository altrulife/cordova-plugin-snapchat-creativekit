#import <Cordova/CDVPlugin.h>

@interface CDVCreativeKit : CDVPlugin {}

- (void)sharePhoto:(CDVInvokedUrlCommand*)command;
- (void)shareVideo:(CDVInvokedUrlCommand*)command;
- (void)shareToCameraPreview:(CDVInvokedUrlCommand*)command;
- (void)shareLensToCameraPreview:(CDVInvokedUrlCommand*)command;

@end
