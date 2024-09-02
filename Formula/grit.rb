class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1725259152"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725259152/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "e962ac6e77415bd798c352863d541ae2ffe3aef35f953489b9e018ea42220dd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725259152/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "81bae0bfc7ea2fd8de6408862f9ac4df61c38d1f0b7e6ea72d06fc4387ff817d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725259152/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "001a45408c68b0adaf963406ae66a76c86f5cc0a76d100ae32318da6dc1e496c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725259152/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d15b0eab2f31942eaeee3f48416f20e06a3a268776b49b710fde88316b3f886e"
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
