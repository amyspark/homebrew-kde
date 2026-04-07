class QcaAT2 < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.10/qca-2.3.10.tar.xz"
  sha256 "1c5b722da93d559365719226bb121c726ec3c0dc4c67dea34f1e50e4e0d14a02"
  license "LGPL-2.1-or-later"
  revision 3

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt@5"

  fails_with gcc: "5"

  keg_only :versioned_formula

  def install
    # Make sure we link with OpenSSL 3 and not OpenSSL 1.1.
    openssl11 = Formula["openssl@1.1"]
    ENV.remove "CMAKE_PREFIX_PATH", openssl11.opt_prefix
    ENV.remove ["CMAKE_INCLUDE_PATH", "HOMEBREW_INCLUDE_PATHS"], openssl11.opt_include
    ENV.remove ["CMAKE_LIBRARY_PATH", "HOMEBREW_LIBRARY_PATHS"], openssl11.opt_lib

    args = %W[-DBUILD_TESTS=OFF -DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins]

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    %w[botan gcrypt gnupg nss pkcs11].each do |plugin|
      args << "-DWITH_#{plugin}_PLUGIN=ON"
    end

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qcatool-qt5", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end
