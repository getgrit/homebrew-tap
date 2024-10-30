class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1730245890"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1730245890/grit-aarch64-apple-darwin.tar.gz"
      sha256 "092504fc01266a4010f4c4e1a9ffea0196ffe417ae0a6e0638ddc939629345cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1730245890/grit-x86_64-apple-darwin.tar.gz"
      sha256 "b4ce5f83a71cc44fe0fe4a6bb1bd4c454d7b9d28eece4dda911ebf1af5054e5a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1730245890/grit-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06a1251559b97f3cae0492eee740fa38bbb1428502703f6797d197827ee30eb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1730245890/grit-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f5b9868d39434c67922f1a31d5984877a39012aa86777e52d026595108d33e33"
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
