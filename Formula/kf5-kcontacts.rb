require_relative "../lib/cmake"

class Kf5Kcontacts < Formula
  desc "Address book API for KDE"
  homepage "https://api.kde.org/kcontacts-index.html"
  url "https://download.kde.org/stable/frameworks/5.116/kcontacts-5.116.0.tar.xz"
  sha256 "f107fdec8f52f7362499159c958e57e3b8b1981b0d797a90685c4a604156b4cb"
  head "https://invent.kde.org/frameworks/kcontacts.git", branch: "kf5"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcodecs"
  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
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
    (testpath/"CMakeLists.txt").write("find_package(KF5Contacts REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
