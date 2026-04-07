class KarchiveAT5 < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.116/karchive-5.116.0.tar.xz"
    sha256 "1663e3c970b84063ece7f28548a87c97bc7592e79da0a0afaa4f6354f8dea30a"
    depends_on "qt@5"
  end
  revision 1

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules@5" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  keg_only :versioned_formula

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end
