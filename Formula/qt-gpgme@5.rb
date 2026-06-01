class QtGpgmeAT5 < Formula
  desc "GnuPG Made Easy (Qt bindings)"
  homepage "https://gnupg.org/software/gpgme/index.html"
  license "GPL-2.0"
  url "https://gnupg.org/ftp/gcrypt/qgpgme/qgpgme-2.1.0.tar.xz"
  sha256 "5b32feb3eee4a7f9402d22b7206480908dc43bb4df382917c075c512116f8f08"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt@5"
  depends_on "gpgmepp"

  keg_only :versioned_formula

  def install
    system "cmake", "-S", ".", "-B", "build", 
      "-DBUILD_WITH_QT5=ON",
      "-DBUILD_WITH_QT6=OFF",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "false"
  end
end
