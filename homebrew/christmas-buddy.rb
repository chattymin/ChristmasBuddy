cask "christmas-buddy" do
  version "1.1.0"
  sha256 :no_check  # 실제 배포 시 sha256 해시 추가 필요

  url "https://github.com/chattymin/ChristmasBuddy/releases/download/v#{version}/ChristmasBuddy-v#{version}.dmg"
  name "Christmas Buddy"
  desc "Cute Christmas desktop companion for macOS"
  homepage "https://chattymin.github.io/ChristmasBuddy/"

  app "ChristmasBuddy.app"

  postflight do
    # quarantine 속성 제거
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/ChristmasBuddy.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.christmas.buddy.plist",
    "~/Library/Caches/com.christmas.buddy",
  ]
end
