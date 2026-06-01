require_relative "../lib/cmake"

class Kf5Kidentitymanagement < Formula
  desc "Library to assist in handling user identities"
  homepage "https://api.kde.org/legacy/kdepim/kidentitymanagement/html/index.html"
  url "https://download.kde.org/Attic/release-service/23.08.5/src/kidentitymanagement-23.08.5.tar.xz"
  sha256 "bcd7f7ef26a24b2d198a7739bdc8b4f3868d42e05355173fbc91a95220d77201"
  license "GPL-2.0"

  keg_only :versioned_formula

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kpimtextedit"
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
