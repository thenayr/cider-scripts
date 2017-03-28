#!/bin/bash -le

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  echo "Xcode already installed"
else
  echo "Installing xcode tools"
  xcode-select --install
fi

exists()
{
  command -v "$1" >/dev/null 2>&1
}

echo "Installing pip"
if exists pip; then
  echo "Pip already installed"
else
  sudo easy_install pip
fi

echo "Installing cider"
if exists cider; then
  echo "Cider already installed"
else
  sudo pip install -U cider
fi

echo "Installing homebrew"
if exists brew; then
  echo "Brew already installed"
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


echo "Setting optimizations for osx"

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

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Restart Finder & Dock
echo "Restarting finder and dock"
killall Finder
killall Dock

echo "Run cider setup"
cider restore

if [ ! -d "~/.config/omf" ]; then
  echo "Oh my fish already installed"
else
  echo '/usr/local/bin/fish' | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/fish
  curl -L http://get.oh-my.fish | fish
fi

echo ">>>>>>>>Finished<<<<<<<<"
