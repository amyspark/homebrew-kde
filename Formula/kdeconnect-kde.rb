require_relative "../lib/cmake"

class KdeconnectKde < Formula
  desc "Multi-platform app that allows your devices to communicate"
  homepage "https://community.kde.org/KDEConnect"
  url "https://download.kde.org/stable/release-service/23.08.2/src/kdeconnect-kde-23.08.2.tar.xz"
  sha256 "36621b8aac77e36b2650c0daf8376004f889d924eadf457d5d02a4d7b0013bb6"
  head "https://invent.kde.org/network/kdeconnect-kde.git", branch: "master"
  revision 1

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kdeclarative" => :build
  depends_on "ninja" => :build
  depends_on "gettext"
  depends_on "hicolor-icon-theme"
  depends_on "kde-mac/kde/kf5-kcmutils"
  depends_on "kde-mac/kde/kf5-kconfigwidgets"
  depends_on "kde-mac/kde/kf5-kdbusaddons"
  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-kio"
  depends_on "kde-mac/kde/kf5-kirigami2"
  depends_on "kde-mac/kde/kf5-knotifications"
  depends_on "kde-mac/kde/kf5-kpeople"
  depends_on "kde-mac/kde/kf5-kservice"
  depends_on "kdoctools@5"
  depends_on "ki18n@5"
  depends_on "qca@2"
  depends_on "kde-mac/kde/qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    assert_match "help", shell_output("#{bin}/kdeconnect-cli --help")
  end
end
