class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1723410110"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723410110/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "669197cff06e3ea2308238f0be07a5b5023003d3f762bc5be39d35abba9eaf88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723410110/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "7846200f7d5dca72e6488436968a55e058c55a91b455ecb4fa79d1d170e02e8a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723410110/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c3d2541f2f5255490e850d33d75841ca2ed9774604d9f333f4b12732efcd7b7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723410110/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfdf287f5d2fbefab746863627e3ecdb97fa241fae159fd9f16aebd1544dbf01"
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
