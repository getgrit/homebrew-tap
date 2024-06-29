class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1719643454"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1719643454/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "3c50da3b5ed4713b4979a2b98059df89d8958fd72adb275d710aa12f9e4f24fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1719643454/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "af33351bef9d3e24360ecbd5efbc4f27662095a82b9c07387d7b4a5811b82ab5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1719643454/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "75e8f0f9981d45825d0826956df44a799cb73b5e0cb28863d63435a5576e17e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1719643454/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "968fe984704087a4f02a1d081f8541d34b7c293ecdd13bcbdc4a43acec4c6a33"
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
