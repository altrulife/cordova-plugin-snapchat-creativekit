var exec = require('cordova/exec');

// open Snapchat camera with caption, sticker, and/or attachmentUrl
exports.shareToCameraPreview = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'shareToCameraPreview', [arg0]);
};

// share a photo to Snapchat with optional caption, sticker, and/or attachmentUrl
exports.sharePhoto = function (arg0, success, error) {
    exec(success, error, 'CDVCreativeKit', 'sharePhoto', [arg0]);
};
