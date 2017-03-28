#!/bin/bash -le

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  echo "Xcode already installed"
else
  echo "Installing xcode tools"
  xcode-select --install
fi

echo "Installing pip"
sudo easy_install pip

echo "Installing cider"
sudo pip install -U cider

echo "Run cider setup"
cider restore

# Disable Photos app to open automatically
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# Disable iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool NO
sudo defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.SetupAssistant" DidSeeCloudSetup -bool YES

# Enable shutdown dialog
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool NO

# Accelerated playback on window size adjustment for Cocoa apps
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Faster keystroke reactions
defaults write NSGlobalDomain KeyRepeat -int 0

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType none

# Disable smart quotes & dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable keyboard illumination on 5 minutes standby
defaults write com.apple.BezelServices kDimTime -int 300

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable disk verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Show POSIX path as finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
#
# Finder status bar originating from $HOME instead of /
defaults write /Library/Preferences/com.apple.finder PathBarRootAtHome -bool YES

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Restart Finder & Dock
killall Finder
killall Dock
