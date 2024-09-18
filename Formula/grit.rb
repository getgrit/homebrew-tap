class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1726637285"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726637285/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "8f27d853e9ac30778b2000c3f274751d565e1abbe55b9977b10231d8268b0ec0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726637285/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "65d04d85a6c3a9bdeea2527905244ef1943a0968a8ce7818bacb52ca5cc3b90b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726637285/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55d223e1b7ed671d89846e53d2786fcb55ff162fb37ea9cfa1b84d124f633701"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726637285/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dbc97fac1ba7489a836d6a8b965e49966b74d76b49b65e9548def0b78fe6751b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {
      marzano: [
        "grit",
      ],
    },
    "aarch64-unknown-linux-gnu": {
      marzano: [
        "grit",
      ],
    },
    "x86_64-apple-darwin":       {
      marzano: [
        "grit",
      ],
    },
    "x86_64-pc-windows-gnu":     {
      "marzano.exe": [
        "grit.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":  {
      marzano: [
        "grit",
      ],
    },
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
    bin.install "marzano" if OS.mac? && Hardware::CPU.arm?
    bin.install "marzano" if OS.mac? && Hardware::CPU.intel?
    bin.install "marzano" if OS.linux? && Hardware::CPU.arm?
    bin.install "marzano" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
