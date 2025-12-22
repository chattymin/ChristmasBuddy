cask "christmas-buddy" do
  version "1.1.0"
  sha256 :no_check

  url "https://github.com/chattymin/ChristmasBuddy/releases/download/v#{version}/ChristmasDesktopBuddy-v#{version}.dmg"
  name "Christmas Desktop Buddy"
  desc "Cute Christmas desktop companion for macOS"
  homepage "https://chattymin.github.io/ChristmasBuddy/"

  app "ChristmasDesktopBuddy.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/ChristmasDesktopBuddy.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.christmas.desktopbuddy.plist",
    "~/Library/Caches/com.christmas.desktopbuddy",
  ]
end
