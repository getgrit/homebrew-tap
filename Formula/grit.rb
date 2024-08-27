class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1724799132"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724799132/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "fc594ad6408316923dfe350e0cc0c6c628f749c318bce497a9af0984c401ffe0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724799132/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "ad3280fe0e3feff4ae793f3eefc76bcec3157ee29f9ff91c93b7935c90f3523c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724799132/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "28cf63fe19a7319e25ff35258221e61cffb49ec039d35b9b80244d42a23bab28"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {"marzano": ["grit"]}, "x86_64-apple-darwin": {"marzano": ["grit"]}, "x86_64-pc-windows-gnu": {"marzano.exe": ["grit.exe"]}, "x86_64-unknown-linux-gnu": {"marzano": ["grit"]}}

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
      bin.install "marzano"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "marzano"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "marzano"
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
