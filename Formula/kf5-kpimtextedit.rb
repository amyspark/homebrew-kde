require_relative "../lib/cmake"

class Kf5Kpimtextedit < Formula
  desc "Library to assist in handling user identities"
  homepage "https://api.kde.org/legacy/kdepim/kpimtextedit/html/index.html"
  url "https://download.kde.org/Attic/release-service/23.08.5/src/kpimtextedit-23.08.5.tar.xz"
  sha256 "4edc962b0c8202c192b3c9c6faaba0996e88df99609500abb54f55b768e727c7"
  license "GPL-2.0"

  keg_only :versioned_formula

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcodecs"
  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-kwidgetsaddons"
  depends_on "kde-mac/kde/kf5-kxmlgui"
  depends_on "kde-mac/kde/kf5-syntax-highlighting"
  depends_on "ki18n@5"

  depends_on "qt@5"

  keg_only :versioned_formula

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5IdleTime REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
