class Grit < Formula
  desc "GritQL is a query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  version "0.1.0-alpha.1726367269"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726367269/marzano-aarch64-apple-darwin.tar.gz"
      sha256 "5eafb4894b37ddb9fae919a84ccf26eab79034c85ac1285ed54ed15d90f68c6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726367269/marzano-x86_64-apple-darwin.tar.gz"
      sha256 "2fd82eaf422271342db6dbb85985a7ffec56d8f19c03a48db45e7fc02f5f8bd6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726367269/marzano-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e49d05d210b06a8f498f9accaba37ffc856c49766eb1dd0c41c95f8aff383d74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1726367269/marzano-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ead6872465f25ebcd4dcea40985acbfe7b39b5ce663230c15ece52f053df4115"
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
