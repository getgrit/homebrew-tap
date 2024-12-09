class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1733706700"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733706700/grit-aarch64-apple-darwin.tar.gz"
      sha256 "90f05de03143af1c5dbd69e38e528a8521c59f2f945fc9b5cda97ed64b1051c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733706700/grit-x86_64-apple-darwin.tar.gz"
      sha256 "f52708296bdc422cf8f487df97e48c367d7cdaa61e9e2d2f5135d46f07cb2bbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733706700/grit-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aca98e9f788fe7c14062503340430d1c2d22ccdf32df67bff09a72efd2d9d521"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733706700/grit-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "192d41b673b587f0499b531e9ebec7e455fec57583efbea1e6b468969e62dd81"
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
