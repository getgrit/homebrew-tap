class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1736234933"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1736234933/grit-aarch64-apple-darwin.tar.gz"
      sha256 "d52071f4ece793e8a15693062d92f369753d9d61c5a53c769b6dbdc961245627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1736234933/grit-x86_64-apple-darwin.tar.gz"
      sha256 "a901b5ed9d7a4dbccc133aafb237b42fd26424533192eeca627d82ebc8dcbfac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1736234933/grit-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b5c2c1fa2dccad182ab8e0fd9b005cfc745d756fe8ff74af08500601f17ac14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1736234933/grit-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da01d899b39908fb900f24b9579f89987b82e15fd28faca8132c0a80e55ba098"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "grit" if OS.mac? && Hardware::CPU.arm?
    bin.install "grit" if OS.mac? && Hardware::CPU.intel?
    bin.install "grit" if OS.linux? && Hardware::CPU.arm?
    bin.install "grit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
