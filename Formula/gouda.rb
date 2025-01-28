class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1738053820"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "7277ee7ae92215625f4f8b9aacba6e0a9c34559e1688d34786a3090b48f96ab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "7c6295e16f986deb9c37131d6bb6b69b5d1c1d84478f30f0540eb70bbbe92262"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3b2bb8e4d0801349759f064b227119cf2ab45c6693d7076fc40c145de7a3a91c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5bdfe834800ad6ef72a65312014e2b466fc37e962971233cf327059e21f4c3db"
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
