require_relative "../lib/cmake"

class Libalkimia < Formula
  desc "Library used by KDE Finance applications"
  homepage "https://kmymoney.org"
  url "https://download.kde.org/stable/alkimia/8.2.1/alkimia-8.2.1.tar.xz"
  sha256 "f921410e180e0a5811e1ee2926954920c6576a72b3b65f53791faa6c85fcb689"
  revision 1

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "gettext"
  depends_on "gmp"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-knewstuff"

  def install
    system "cmake", "-DBUILD_APPLETS=OFF", "-DBUILD_WITH_WEBKIT=OFF", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(LibAlkimia5 REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
