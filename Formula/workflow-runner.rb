class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1724196501"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724196501/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "c0aaced908cfd9cc6093a503fc859069ba3936f9a6049d4bb2d7bf6f60dd3b8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724196501/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "291a091ada8b526e8e929c26fdcf71c91efc14e55b81aec0c2c3a8a31e9ca0d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724196501/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5873eb6ad25e8b92b1be5985adcf3e4f1b02b5e40d009f41cd0db6704d714ecb"
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
