class LibicalAT3 < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.20/libical-3.0.20.tar.gz"
  sha256 "e73de92f5a6ce84c1b00306446b290a2b08cdf0a80988eca0a2c9d5c3510b4c2"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 4

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"

  keg_only :versioned_formula

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    # Broken upstream -- uses an incorrect extra level of indirection
    # https://github.com/Homebrew/brew/blame/main/Library/Homebrew/formula.rb#L2298
    args = %W[
      -DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND
      -DENABLE_GTK_DOC=OFF
      -DSHARED_ONLY=ON
      -DCMAKE_INSTALL_RPATH=@loader_path
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
