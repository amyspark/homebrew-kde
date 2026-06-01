class Kf5Akonadi < Formula
  desc "Akonadi aims to be an extensible cross-desktop storage service for PIM data and meta data providing concurrent read, write, and query access."
  homepage "https://kontact.kde.org/components/akonadi/"
  url "https://download.kde.org/Attic/release-service/23.08.5/src/akonadi-23.08.5.tar.xz"
  sha256 "abdbdb28c1084a6ad119d7292175ad31efb4a7898a32cc32a35aa1485d9c4f38"
  license "GPL-2.0"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kitemmodels"
  depends_on "ki18n@5"

  depends_on "qt@5"

  keg_only :versioned_formula

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end
end
