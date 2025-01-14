#!/bin/sh

set -e # Exit on error

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

log_info() {
    echo "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo "${RED}[ERROR]${NC} $1"
}

create_directory_if_not_exists() {
    local dir_path=$1
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        log_info "Created directory: $dir_path"
    else
        log_info "Directory already exists: $dir_path"
    fi
}

create_firebase_plist() {
    local plist_path=$1
    
    if [ -f "$plist_path" ]; then
        log_info "Firebase plist already exists at: $plist_path"
        return
    fi

    cat <<EOF > "$plist_path"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string></string>
    <key>REVERSED_CLIENT_ID</key>
    <string></string>
    <key>API_KEY</key>
    <string></string>
    <key>GCM_SENDER_ID</key>
    <string></string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string></string>
    <key>PROJECT_ID</key>
    <string></string>
    <key>STORAGE_BUCKET</key>
    <string></string>
    <key>IS_ADS_ENABLED</key>
    <false/>
    <key>IS_ANALYTICS_ENABLED</key>
    <false/>
    <key>IS_APPINVITE_ENABLED</key>
    <true/>
    <key>IS_GCM_ENABLED</key>
    <true/>
    <key>IS_SIGNIN_ENABLED</key>
    <true/>
    <key>GOOGLE_APP_ID</key>
    <string></string>
</dict>
</plist>
EOF
    log_info "Created Firebase plist at: $plist_path"
}

main() {
    # Create config directories
    CONFIG_DIR='../Armony/Resources/Configs'
    create_directory_if_not_exists "$CONFIG_DIR"
    
    # Create config files
    touch "$CONFIG_DIR/ReleaseConfiguration.xcconfig"
    touch "$CONFIG_DIR/DebugConfiguration.xcconfig"
    log_info "Created configuration files"
    
    # Create Firebase directory and files
    FIREBASE_DIR='../Armony/Resources/Firebase'
    create_directory_if_not_exists "$FIREBASE_DIR"
    
    # Create Firebase plists
    create_firebase_plist "$FIREBASE_DIR/GoogleService-Info-Debug.plist"
    create_firebase_plist "$FIREBASE_DIR/GoogleService-Info.plist"
    
    log_info "Post-clone setup completed successfully"
}

# Execute main function
main
