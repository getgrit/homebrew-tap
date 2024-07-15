class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1721010136"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1721010136/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "5590c8fc963d895b0701bd4a8dedd8398afcd0fa8ec35924aa01fb70728f4176"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1721010136/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "da4fd556e8c77295bb9ce83790bd41f5e9699865534369e3ef18c9deda5e79f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1721010136/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "114a44c99ec1b341c6d872275dac7534fbfc22c7923de57c0cf39ad2e81af17e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1721010136/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6b08c3c0e3fd08b904ae8469dd76602ce9575ddb3986c7f1707d09c13e53f4a9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {"marzano": ["grit"]}, "aarch64-unknown-linux-gnu": {"marzano": ["grit"]}, "x86_64-apple-darwin": {"marzano": ["grit"]}, "x86_64-pc-windows-gnu": {"marzano.exe": ["grit.exe"]}, "x86_64-unknown-linux-gnu": {"marzano": ["grit"]}}

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
    if OS.linux? && Hardware::CPU.arm?
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
