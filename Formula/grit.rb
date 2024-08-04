class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1722786880"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722786880/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "545f17141acb4b1d4270bbf73a7f4377cecfca38f2c156a99e59c76d7e355681"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722786880/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "74faa4efe54d05e9582e90ad25972233a09f5319bb873541238722cf605e9dee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722786880/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "45f2f2b6b3567c12fb6d5ebd2253054207cd4736174f2c9d50919255598f5184"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722786880/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "582099ca5ac9dd419e64c65c59280d96a90cd8476c0a6472f9ad1c09f535a2fc"
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
