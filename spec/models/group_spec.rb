require 'rails_helper'

describe Group do

  let(:group)    { Group.new(name: name, password: password) }
  let(:name)     { "Hooroo" }
  let(:password) { "password" }

  it "is valid" do
    expect(group.valid?).to be true
  end

  it "requires a name" do
    group.name = nil
    puts "name: #{name}"
    expect(group.valid?).to be false
  end

  it "requires a password" do
    group.password = nil
    expect(group.valid?).to be false
  end

  it "requires a password at least six characters in length" do
    group.password = "short"
    expect(group.valid?).to be false
  end

end