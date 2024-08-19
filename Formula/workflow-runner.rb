class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1724089676"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724089676/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "af3933ae6d3ccd0ace5a4475312fe61beb76a3c375f1e6752f5f4e14363f0f2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724089676/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "c74398fec8f17943a6479831749df3fe89c524ad654b08f4b043f1c2b7206be3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724089676/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29e9aa24ffe186502397e7e4477b5af1c9fceac2709e927eebfc7abdc43aabf8"
    end
  end
  license "UNLICENSED"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "workflow-runner"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "workflow-runner"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "workflow-runner"
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
