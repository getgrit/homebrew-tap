class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1731564935"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1731564935/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "ec3c6a4c2ad161ab226bb13d7a390bf8a83f148f1add5c8052bc50dd12421fc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1731564935/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "ba85917a0894547d6dabe95be757c11d0a07e8b355315e6fe8504e158bf413fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1731564935/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "672d22888d53c5b91db0cde7834d48c29a495c84d37489c433956c5e6e3add68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1731564935/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10e375f577aa185e12cb7e3e19c0cc250e78f17fb6c3f93f2719714af52e1659"
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
    bin.install "gouda" if OS.mac? && Hardware::CPU.arm?
    bin.install "gouda" if OS.mac? && Hardware::CPU.intel?
    bin.install "gouda" if OS.linux? && Hardware::CPU.arm?
    bin.install "gouda" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
