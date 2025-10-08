class ExtraCmakeModulesAT5 < Formula
  desc "Extra modules and scripts for CMake (version 5.x)"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules@5/html/index.html"

  stable do
    url "https://download.kde.org/stable/frameworks/5.116/extra-cmake-modules@5-5.116.0.tar.xz"
    sha256 "e8f6d11a6ef478171f845d376523ad5c56e8f7fd4bae8791942cecba0b23cd08"
    depends_on "qt@5" => :build
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  keg_only :versioned_formula

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end
