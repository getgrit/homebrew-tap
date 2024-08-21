class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1724218977"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724218977/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "76525d76554b9e30ae883daa5dd98fc56362103b6ed029e04566c90c45c28e89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724218977/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "840ce496dba8dcc222a7353d746aadb48ee4219ad51ff9c511ea39744b85214e"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724218977/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c3532493bf8bf1b0143b3f4af6c479a27c953aba0b14bb1d7502d750f6edcff4"
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
