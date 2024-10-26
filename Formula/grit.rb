class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1729976046"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729976046/grit-aarch64-apple-darwin.tar.gz"
      sha256 "2651e80b004890380c5a851ce52590638537c366bfb8b1e68fc5e57470fc15a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729976046/grit-x86_64-apple-darwin.tar.gz"
      sha256 "a24c1a206f7b0be6e14819e027cc2b3429282be3eeefab1f750b6e87737e9680"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729976046/grit-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "609a3b1238c5533b5adc7bdc7dbb82bea5feb671b0c02a35d328ecb9f095fa74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729976046/grit-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ca5c6ef411bb6a21da88ca97933d4b8e4b5a366c19d53fbefb9033261f92231f"
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
