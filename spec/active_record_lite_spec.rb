require "spec_helper"

describe ActiveRecordLite, use_connection: true do

    let(:user) { User.where(id: 1).to_lite }

    let(:company) { Company.where(id: 1).to_lite }

    it "to_lite for a single record returns a ActiveRecordLite object for that class" do
        User.create(name: "test", email: "test@example.com", preferences: {test: true})
        expect(user).to be_kind_of(User::ActiveRecordLite)
    end

    it "to_lite for a multiple records returns an array of ActiveRecordLite objects" do
        User.create(name: "test2", email: "test2@example.com")
        users = User.to_lite
        expect(users).to be_kind_of(Array)
        expect(users[0]).to be_kind_of(User::ActiveRecordLite)
    end

    it "must respond to all model properties" do
        expect(user.id).to eq(1)
        expect(user.name).to eq("test")
        expect(user.email).to eq("test@example.com")
    end

    it "must serialize serialized columns" do
        expect(user.preferences).to eq({test: true})
    end

    it "must return datetime in correct timezone" do
        Time.zone = "Chennai"
        expect(user.created_at.zone).to eq("IST")
    end

    it "must not respond to unsupported model properties" do
        Company.create(name: "test", location: "India", active: 1)
        expect(company.name).to eq("test")
        expect { company.location }.to raise_error(NoMethodError)
    end

    it "must add boolean methods" do
        # need to stub as sqlite3 returns 't'/'f' for bools
        company.stub(:read_attribute) { 1 }
        expect(company.active).to eq(true)
        expect(company.active?).to eq(true)
        company.unstub(:read_attribute)
    end

    it "must allow dynamic selects" do
        dynamic_company = Company.where(id: 1).to_lite(:name, :id)

        expect(dynamic_company.name).to eq("test")
        expect(dynamic_company.id).to eq(1)
    end

    it "must allow only supported properties in dynamic selects" do
        dynamic_company = Company.where(id: 1).to_lite(:id, :location)

        expect { dynamic_company.location }.to raise_error(NoMethodError)
        expect(dynamic_company.id).to eq(1)
        expect(dynamic_company.name).to eq(nil)
    end
end