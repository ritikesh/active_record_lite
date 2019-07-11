require "spec_helper"

describe ActiveRecordLite, use_connection: true do

    it "to_lite for a single record returns a ActiveRecordLite object for that class" do
        User.create(name: "test", email: "test@example.com")
        user = User.where(id: 1).to_lite
        expect(user).to be_kind_of(User::ActiveRecordLite)
    end

    it "to_lite for a multiple records returns an array of ActiveRecordLite objects" do
        User.create(name: "test", email: "test@example.com")
        users = User.to_lite
        expect(users).to be_kind_of(Array)
        expect(users[0]).to be_kind_of(User::ActiveRecordLite)
    end

    it "must respond to all model properties" do
        user = User.where(id: 1).to_lite
        expect(user.id).to eq(1)
        expect(user.name).to eq("test")
        expect(user.email).to eq("test@example.com")
    end

    it "must not respond to unsupported model properties" do
        company = Company.create(name: "test", location: "India")
        company = Company.where(id: 1).to_lite
        expect(company.name).to eq("test")
        expect { company.location }.to raise_error(NoMethodError)
    end
end