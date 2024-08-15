class Minas < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1723691536"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/minas-aarch64-apple-darwin.tar.gz"
      sha256 "f2fb06ecc45e910164a3d536c7e99291c1b75fd3aaac7cf3a3b65e917bf5dc89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/minas-x86_64-apple-darwin.tar.gz"
      sha256 "922d8d783e0a6c9b79eff28073f7aeed9ab83ee0a4841f56b7e6506971b206bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/minas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4c59d1cbd3c182d560c2c56ea1a27ba23de0664f7c2ef902d3b10aedaa51ace"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/minas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c49875861aba73fb84b052b1be310904dc0506140284234cab9ed761e30ca185"
    end
  end
  license "UNLICENSED"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "minas"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "minas"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "minas"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "minas"
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
