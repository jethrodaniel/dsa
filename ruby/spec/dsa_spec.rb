RSpec.describe DSA do
  describe "::VERSION" do
    subject { described_class::VERSION }

    it { is_expected.to eq("0.0.0") }
  end
end
