shared_examples 'it has an attribute for' do |attribute, default_value = nil|
  it "the attribute '#{attribute}'" do
    obj = described_class.new
    expect(obj.send(attribute)).to eq default_value
    obj.send("#{attribute}=", :foo)
    expect(obj.send(attribute)).to eq :foo
  end
end
shared_examples 'a Moodle2CC::CanvasCC::Model::Resource' do
  it "by inheriting Moodle2CC::CanvasCC::Model::Resource" do
    expect(described_class.ancestors).to include Moodle2CC::CanvasCC::Model::Resource
  end
end