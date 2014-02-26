shared_examples 'it has an attribute for' do |attribute, default_value = nil|
  it "the attribute '#{attribute}'" do
    obj = described_class.new
    expect(obj.send(attribute)).to eq default_value
    obj.send("#{attribute}=", :foo)
    expect(obj.send(attribute)).to eq :foo
  end
end