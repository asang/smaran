# vim: set et ts=2 sw=2 et:
require 'spec_helper'

describe Label, :type => :model do
  let(:label) { FactoryGirl.build(:label) }
  subject { label }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:account_ids) }

  describe "Validations" do
    describe "name" do
      it "is required" do
        label.name = nil
        expect(label).to_not be_valid
        expect(label).to have(2).error_on(:name)
        expect(label.errors_on(:name)).to include( 'is invalid' )
        expect(label.errors_on(:name)).to include( 'can\'t be blank' )
      end
      it "should be valid" do
        names = [ 'Name1', '012N', 'abc', 'two words', 'ws ' ]
        names.each do |vn|
          label.name = vn
          expect(label).to be_valid
          label.save!
          expect(label.name).to eql(vn.downcase)
        end
      end
      it "should be invalid" do
        invalid_names = [ '/12', '*lbl', '!sdsds', 'nm/' ]
        invalid_names.each do |n|
          label.name = n
          expect(label).to_not be_valid
          expect(label).to have(1).error_on(:name)
          expect(label.errors_on(:name)).to include('is invalid')
        end
      end
    end

    describe "description" do
      it "is required" do
        label.description = nil
        expect(label).to_not be_valid
        expect(label).to have(1).error_on(:description)
        expect(label.errors_on(:description)).to include( 'can\'t be blank' )
      end
      it "is saved" do
        label.description = 'New Description'
        expect { label.save }.to change(Label, :count).from(0).to(1)
      end
    end
  end

  describe "Delete" do
    it "referenced label shouldn't be deleted" do
      account = FactoryGirl.build(:account)
      account.save
      label.accounts << account
      label.save!
      expect { label.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
    it "unreferenced label should be deleted" do
      expect { label.save }.to change(Label, :count).from(0).to(1)
      expect { label.destroy! }.to change(Label, :count).from(1).to(0)
    end
  end

  it "Sorted by name" do
    l1 = FactoryGirl.build(:label, name: '1st Name')
    l2 = FactoryGirl.build(:label, name: '2nd Name')
    l1.save
    l2.save
    assert Label.sorted_labels == [l1, l2], "expected [l1, l2]"
  end
end
