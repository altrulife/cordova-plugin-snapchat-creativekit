var xcode = require('xcode');
var fs = require('fs');
var path = require('path');


function fromDir(startPath, filter) {
  if (!fs.existsSync(startPath)) {
    console.log("no dir ", startPath);
    return;
  }
  const folder = fs.readdirSync(startPath).filter(p => p.endsWith(filter))[0];
  if (!folder) {
    console.log("no dir ending with ", filter);
    return;
  }
  return path.join(startPath, folder);
}

var options = {
  shellPath: '/bin/sh',
  shellScript: `
# Only run in Release mode so can deploy to Phone and emulators
if [ "$CONFIGURATION" != "Debug" ]; then
  APP_PATH="\${TARGET_BUILD_DIR}/\${WRAPPER_NAME}"

  # This script loops through the frameworks embedded in the application and
  # removes unused architectures.
  find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
  do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
        lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
        EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo "Merging extracted architectures: \${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "\${EXTRACTED_ARCHS[@]}"
    rm "\${EXTRACTED_ARCHS[@]}"

    # Check $FRAMEWORK_EXECUTABLE_PATH-merged (thin file) exists then replace to the original version (fat file)
    # See: https://stackoverflow.com/questions/68356898/error-itms-90085-no-architectures-in-the-binary
    if [ -f "$FRAMEWORK_EXECUTABLE_PATH-merged" ]; then
      echo "Replacing original executable with thinned version"
      rm "$FRAMEWORK_EXECUTABLE_PATH"
      mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"
    fi

  done
fi
`
};

module.exports = context => {
  const xcodeProjPath = fromDir('platforms/ios', '.xcodeproj');
  if (!xcodeProjPath) {
    // nothing to add or remove yet
    return;
  }
  const projectPath = xcodeProjPath + '/project.pbxproj';
  if (
    context.hook === 'after_platform_add' ||
    context.hook === 'after_plugin_add' ||
    (context.hook === 'before_plugin_rm' && context.opts.plugin.id === 'cordova-plugin-snapchat-creativekit')
  ) {
    const myProj = xcode.project(projectPath);
    myProj.parse(function(err) {
      const exists = myProj.buildPhaseObject('PBXShellScriptBuildPhase', 'Remove unused architectures');
      // always remove and re-add, so we can ensure this build phase is last
      if (exists) {
        const target = myProj.getFirstTarget().firstTarget;
        // remove from buildPhases
        const buildPhases = target.buildPhases.filter(p => p.comment !== 'Remove unused architectures');
        target.buildPhases = buildPhases;
        fs.writeFileSync(projectPath, myProj.writeSync());
      }
    });
  }
  if (
    context.hook === 'after_platform_add' ||
    context.hook === 'after_plugin_add'
  ) {
    const myProj = xcode.project(projectPath);

    myProj.parse(function(err) {
      const exists = myProj.buildPhaseObject('PBXShellScriptBuildPhase', 'Remove unused architectures');
      // don't add twice
      if(!exists) {
        myProj.addBuildPhase([], 'PBXShellScriptBuildPhase', 'Remove unused architectures', myProj.getFirstTarget().uuid, options);
        fs.writeFileSync(projectPath, myProj.writeSync());
      }
    });
  }
};
