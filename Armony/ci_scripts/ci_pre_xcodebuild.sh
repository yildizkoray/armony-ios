#!/bin/sh

set -e # Exit on error

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo "${RED}[ERROR]${NC} $1"
    exit 1
}

log_warning() {
    echo "${YELLOW}[WARNING]${NC} $1"
}

check_required_env_vars() {
    local missing_vars=()
    
    # Firebase variables
    local firebase_vars=(
        "FIREBASE_CLIENT_ID"
        "FIREBASE_REVERSED_CLIENT_ID"
        "FIREBASE_API_KEY"
        "FIREBASE_GCM_SENDER_ID"
        "FIREBASE_PLIST_VERSION"
        "FIREBASE_BUNDLE_ID"
        "FIREBASE_PROJECT_ID"
        "FIREBASE_STORAGE_BUCKET"
        "FIREBASE_IS_ADS_ENABLED"
        "FIREBASE_IS_ANALYTICS_ENABLED"
        "FIREBASE_IS_APPINVITE_ENABLED"
        "FIREBASE_IS_GCM_ENABLED"
        "FIREBASE_IS_SIGNIN_ENABLED"
        "FIREBASE_GOOGLE_APP_ID"
    )
    
    # Facebook variables
    local facebook_vars=(
        "FACEBOOK_APP_ID"
        "FACEBOOK_CLIENT_TOKEN"
    )
    
    # Analytics variables
    local analytics_vars=(
        "MIXPANEL_TOKEN"
        "ADJUST_TOKEN"
    )
    
    # Check all variables
    for var in "${firebase_vars[@]}" "${facebook_vars[@]}" "${analytics_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        log_error "Missing required environment variables: ${missing_vars[*]}"
    fi
}

setup_config_path() {
    if [ "$CI_XCODE_SCHEME" == "Armony" ]; then
        echo '../Armony/Resources/Configs/ReleaseConfiguration.xcconfig'
    else
        echo '../Armony/Resources/Configs/DebugConfiguration.xcconfig'
    fi
}

update_config_file() {
    local config_file=$1
    local key=$2
    local value=$3
    
    echo "$key = $value" >> "$config_file"
    log_info "Updated $key in config file"
}

update_plist_file() {
    local plist_file=$1
    local key=$2
    local value=$3
    
    /usr/libexec/PlistBuddy -c "Set :$key $value" "$plist_file"
    log_info "Updated $key in plist file"
}

update_firebase_config() {
    local config_file=$1
    local firebase_configs=(
        "CLIENT_ID:FIREBASE_CLIENT_ID"
        "REVERSED_CLIENT_ID:FIREBASE_REVERSED_CLIENT_ID"
        "API_KEY:FIREBASE_API_KEY"
        "GCM_SENDER_ID:FIREBASE_GCM_SENDER_ID"
        "PLIST_VERSION:FIREBASE_PLIST_VERSION"
        "BUNDLE_ID:FIREBASE_BUNDLE_ID"
        "PROJECT_ID:FIREBASE_PROJECT_ID"
        "STORAGE_BUCKET:FIREBASE_STORAGE_BUCKET"
        "IS_ADS_ENABLED:FIREBASE_IS_ADS_ENABLED"
        "IS_ANALYTICS_ENABLED:FIREBASE_IS_ANALYTICS_ENABLED"
        "IS_APPINVITE_ENABLED:FIREBASE_IS_APPINVITE_ENABLED"
        "IS_GCM_ENABLED:FIREBASE_IS_GCM_ENABLED"
        "IS_SIGNIN_ENABLED:FIREBASE_IS_SIGNIN_ENABLED"
        "GOOGLE_APP_ID:FIREBASE_GOOGLE_APP_ID"
    )
    
    for config in "${firebase_configs[@]}"; do
        IFS=':' read -r plist_key env_key <<< "$config"
        update_config_file "$config_file" "$env_key" "${!env_key}"
    done
}

update_facebook_config() {
    local config_file=$1
    local facebook_configs=(
        "APP_ID:FACEBOOK_APP_ID"
        "CLIENT_TOKEN:FACEBOOK_CLIENT_TOKEN"
    )
    
    for config in "${facebook_configs[@]}"; do
        IFS=':' read -r key env_key <<< "$config"
        update_config_file "$config_file" "FACEBOOK_$key" "${!env_key}"
    done
}

update_analytics_config() {
    local config_file=$1
    local analytics_configs=(
        "MIXPANEL_TOKEN"
        "ADJUST_TOKEN"
    )
    
    for config in "${analytics_configs[@]}"; do
        update_config_file "$config_file" "$config" "${!config}"
    done
}

update_firebase_plist() {
    local plist_file=$1
    local firebase_configs=(
        "CLIENT_ID:FIREBASE_CLIENT_ID"
        "REVERSED_CLIENT_ID:FIREBASE_REVERSED_CLIENT_ID"
        "API_KEY:FIREBASE_API_KEY"
        "GCM_SENDER_ID:FIREBASE_GCM_SENDER_ID"
        "PLIST_VERSION:FIREBASE_PLIST_VERSION"
        "BUNDLE_ID:FIREBASE_BUNDLE_ID"
        "PROJECT_ID:FIREBASE_PROJECT_ID"
        "STORAGE_BUCKET:FIREBASE_STORAGE_BUCKET"
        "IS_ADS_ENABLED:FIREBASE_IS_ADS_ENABLED"
        "IS_ANALYTICS_ENABLED:FIREBASE_IS_ANALYTICS_ENABLED"
        "IS_APPINVITE_ENABLED:FIREBASE_IS_APPINVITE_ENABLED"
        "IS_GCM_ENABLED:FIREBASE_IS_GCM_ENABLED"
        "IS_SIGNIN_ENABLED:FIREBASE_IS_SIGNIN_ENABLED"
        "GOOGLE_APP_ID:FIREBASE_GOOGLE_APP_ID"
    )
    
    for config in "${firebase_configs[@]}"; do
        IFS=':' read -r plist_key env_key <<< "$config"
        update_plist_file "$plist_file" "$plist_key" "${!env_key}"
    done
}

main() {
    log_info "Starting pre-xcodebuild configuration..."
    
    # Check required environment variables
    check_required_env_vars
    
    # Setup config path
    CONFIG_PLIST_PATH=$(setup_config_path)
    log_info "Using config path: $CONFIG_PLIST_PATH"
    
    # Update configurations
    update_firebase_config "$CONFIG_PLIST_PATH"
    update_facebook_config "$CONFIG_PLIST_PATH"
    update_analytics_config "$CONFIG_PLIST_PATH"
    
    # Setup Google plist path
    if [ "$CI_XCODE_SCHEME" == "Armony" ]; then
        INFO_PLIST_PATH='../Armony/Resources/Firebase/GoogleService-Info.plist'
    else
        INFO_PLIST_PATH='../Armony/Resources/Firebase/GoogleService-Info-Debug.plist'
    fi
    log_info "Using Google plist path: $INFO_PLIST_PATH"
    
    # Update Google plist
    update_firebase_plist "$INFO_PLIST_PATH"
    
    log_info "Pre-xcodebuild configuration completed successfully"
}

# Execute main function
main
