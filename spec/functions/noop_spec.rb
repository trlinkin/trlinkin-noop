require 'spec_helper'

describe 'noop' do
  it { is_expected.not_to eq(nil) }

  it { is_expected.to run.with_params }

  it { is_expected.to run.with_params(false) }

  it { is_expected.to run.with_params(true) }

  it { is_expected.to run.with_params('bad_input').and_raise_error(ArgumentError) }

  context "should give every resource a default of 'noop => true' when no argument is passed" do
    let(:pre_condition) { 'noop(); file {"/tmp/foo":}' }

    it {
      expect(catalogue).to contain_file('/tmp/foo').with_noop(true)
    }
  end

  context "should give every resource a default of 'noop => false' when the first argument is boolean false" do
    let(:pre_condition) { 'noop(false); file {"/tmp/foo":}' }

    it {
      expect(catalogue).to contain_file('/tmp/foo').with_noop(false)
    }
  end

  context "should give every resource a default of 'noop => true' when the first argument is boolean true" do
    let(:pre_condition) { 'noop(true); file {"/tmp/foo":}' }

    it {
      expect(catalogue).to contain_file('/tmp/foo').with_noop(true)
    }
  end
end
