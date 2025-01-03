class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1735860266"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1735860266/grit-aarch64-apple-darwin.tar.gz"
      sha256 "3718e3dbaf2d9d5bb5ae7310b6a50dd865250b2a4aa475d38b938fb32e85b48b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1735860266/grit-x86_64-apple-darwin.tar.gz"
      sha256 "bc1bc3f123c2d832014649910d7dd04bd878ee91862d207f364413a338283558"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1735860266/grit-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e59e5925987700051ad10f4ee10e55587d217637a9b377fe8a74d6ea36d6c5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1735860266/grit-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "adbf025d94f1a5826608905d27a2ae9c54903cb562e7a0ec62ac3abdbbd4af52"
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
