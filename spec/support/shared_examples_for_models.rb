shared_examples 'it has an attribute for' do |attribute, default_value = nil|
  it "the attribute '#{attribute}'" do
    obj = described_class.new
    expect(obj.send(attribute)).to eq default_value
    obj.send("#{attribute}=", :foo)
    expect(obj.send(attribute)).to eq :foo
  end
end

shared_examples 'a Moodle2CC::CanvasCC::Models::Resource' do
  it "by inheriting Moodle2CC::CanvasCC::Models::Resource" do
    expect(described_class.ancestors).to include Moodle2CC::CanvasCC::Models::Resource
  end
end

shared_examples 'a Moodle2CC::Moodle2::Models::Quizzes::Question' do
  it "by inheriting Moodle2CC::Moodle2::Models::Quizzes:Question" do
    expect(described_class.ancestors).to include Moodle2CC::Moodle2::Models::Quizzes::Question
  end
end

shared_examples 'it is registered as a Question' do |type|
  it "for the type '#{type}'" do
    expect(Moodle2CC::Moodle2::Models::Quizzes::Question.create(type)).to be_instance_of described_class
  end
end