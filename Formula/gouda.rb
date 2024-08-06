class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1722906402"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722906402/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "1977ba9228f42fb583189bd97195b55c99e90269ada5742c7be6e138e42306d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722906402/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "abf6fd004d712f2158476c972dfb107a03e9ceb3ff6b6431b25ac7c8276546e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722906402/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "19520f4442e63a4c3f4514cd9b6e5189de9df90f8650690107fd4d0fa2a57936"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722906402/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6ec711593536468f12ba0e296c7b448b6b728825017b614d194aa0b1557f3365"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gouda"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gouda"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
