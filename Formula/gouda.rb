class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1722653565"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722653565/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "ee33ef5a962adc84fae799cc6e3a7b57f627f9cb8b2566508b9094bca5659711"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722653565/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "6e6dd034576013bac56316c2f5f42120dee5c1da6711aed23a8427c6fb6a4d37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722653565/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9aa9a3198af9ad7996bdfd9e8cd479bc095fdf9c4d212d1b589da6b3debdbdbe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1722653565/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e88d61c80ff04f779ae12a2444fd8987c3cce06b5eada6507c1efa4d238d062e"
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
