class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1729215008"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729215008/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "624e61f7b1c0f1a4cabd42be3f821e7d54fb3d979d897c8b70ac158ec1781de0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729215008/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "0cba09daf4447b7e33576c370545411e60c8f249ccf7972911b3efc93a0d6179"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729215008/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8e2fbe2f811804fb5e1f074928ea47e8ce74af3488bf7340a3e6f1c643dfd7f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1729215008/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8f287768222c95de6a8ed969dbf8b1ae4c0f969c99091f3522d7da1454f42196"
    end
  end
  license "MIT"

  depends_on "libgit2"

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
