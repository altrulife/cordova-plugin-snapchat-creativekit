var exec = require('cordova/exec');

// share a photo to Snapchat with optional caption, sticker, and/or attachmentUrl
exports.sharePhoto = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'sharePhoto', [arg0]);
};

// share a video to Snapchat with optional caption, sticker, and/or attachmentUrl
exports.shareVideo = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'shareVideo', [arg0]);
};

// open Snapchat camera with caption, sticker, and/or attachmentUrl
exports.shareToCameraPreview = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'shareToCameraPreview', [arg0]);
};

// open Snapchat camera to a particular lense and optionally add a caption and/or attachmentUrl
exports.shareLensToCameraPreview = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'shareLensToCameraPreview', [arg0]);
};
