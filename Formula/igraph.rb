require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.6.tar.gz'
  sha256 '32cdc487f26fae5f746e72a67c170476ac5a93b1384735e7f697c664e7845477'

  option :universal

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless build.universal?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
