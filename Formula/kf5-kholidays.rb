require_relative "../lib/cmake"

class Kf5Kholidays < Formula
  desc "Address book API for KDE"
  homepage "https://api.kde.org/kholidays-index.html"
  url "https://download.kde.org/stable/frameworks/5.116/kholidays-5.116.0.tar.xz"
  sha256 "898fa19e4dbd089a4b00693b8226982f5cbb1751cf4fa21565eb93141b15fdc0"
  head "https://invent.kde.org/frameworks/kholidays.git", branch: "kf5"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "ninja" => :build

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
