require 'spec_helper'

describe "LightNotes::App::NotesHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend LightNotes::App::NotesHelper }
  subject { helpers }

  it "should return nil" do
    expect(subject.foo).to be_nil
  end
end
