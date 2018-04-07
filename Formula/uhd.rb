class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.11.0.1.tar.gz"
  sha256 "b8b0aa9ca347353333c2d6f52193a01b6c7dbcdaf5e21250c00210d3f8b0fabd"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "778a5dac391915959a8927698f15f608bc03281d90972edad6e067c88d1dbcb1" => :high_sierra
    sha256 "571ea3342941f53312d6faa9ed1c306d45213a5e3f52bbd73ed2693f60f4b331" => :sierra
    sha256 "78394f0309cc6ece3417b8bb4cdf27f8cb39f991798f3510d78ac47b5a1858c4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "doxygen" => [:build, :optional]
  depends_on "gpsd" => :optional

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
