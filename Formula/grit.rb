class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1720505779"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1720505779/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "fbabd0203070e4fe854babd1f848d6fb1a8f5b3c5ac8e0ab65a0c180f90264ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1720505779/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "63a9e42734cbeb082ea765a85bbd8c9cad82f067ba6bdd0665845745fc5fc84d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1720505779/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6212350ae6a29606189fc42ad1499982316c548a337d5f406b478bef9b513be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1720505779/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0603f7cce8b7db03ab6a074734e7a9f8b8c6cd8bdfc2eadc28b2f071511e499"
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
