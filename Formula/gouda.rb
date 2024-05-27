class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1716781883"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1716781883/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "2193a1320863598e5dad2b97f1dac1f5a27c6b7009a52d60c317ae4078edbd38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1716781883/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "0bfbea7f9462641663e33bf1c15c2d1c6b1bed11076d6914a8532203429c131d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1716781883/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cc22b11756f76f6d316bfd6d8960db0793d27b10e7c7404285c014aae2ef6c95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1716781883/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "56f318596f337554632dd874b0ccdebf9a283028e1cdacb4df2f022e4252a494"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "gouda"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gouda"
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
