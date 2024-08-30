class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1724988485"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "e631e8d92d227158d63cedfd071ee8a5ca2a79fa9853bb8635d44df440871f47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "6e3b59bc489e3d74d895495bd4168c6e75312ade08963d16ca0345bff477c705"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "527cbcda292d1e7db40abcfbde46a842f4262cbdbc9102ef58a07dfc155b553e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "72a1f8281fc7bf4bd4b935c9d38c8d84184af46e3bc9868bbdabe472f4ef0aaf"
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
