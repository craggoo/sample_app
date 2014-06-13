require 'spec_helper'

describe User do
  
  before do 
  	@User = User.new(name: "Example User", email: "user@example.com",
  						password: "foobar", password_confirmation: "foobar")
  end


  subject { @User }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin}

  describe "with admin attribute set to 'true'" do
    before do
      @User.save!
      @User.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "remember token" do
    before { @User.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "When name is not present" do
  	before { @User.name = " "}
  	it {should_not be_valid}
  end

  describe "When email is not present" do
  	before { @User.email = " "}
  	it {should_not be_valid}
  end

  describe "when name is too long" do
  	before { @User.name = "a" * 51 }
  	it {should_not be_valid}
  end

  describe "when email format is invalid" do
 	it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @User.email = invalid_address
        expect(@User).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @User.email = valid_address
        expect(@User).to be_valid
      end
    end
  end

  describe "when email is already taken" do
  	before do
  		user_with_same_email = @User.dup
  		user_with_same_email.email = @User.email.upcase
  		user_with_same_email.save
  	end
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before do
  		@User = User.new(name: "Example User", email: "user@example.com", 
  							password: " ", password_confirmation: " ")
  	end
  	it { should_not be_valid }
  end

  	describe "when password doesn't match confirmation" do
  		before { @User.password_confirmation = "mismatch" }
  		it { should_not be_valid }
  	end

  	describe "return value of authenticate method" do
  		before { @User.save }
  		let(:found_user) { User.find_by(email: @User.email) }

  		describe "with valid password" do
  			it { should eq found_user.authenticate(@User.password) }
  		end

  		describe "with invalid password" do
  			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  			it { should_not eq user_for_invalid_password }
  			it { expect(user_for_invalid_password).to be_false }
  		end
  	end

  	describe "with a password that's too short" do
  		before {@User.password = @User.password_confirmation = "a" * 5}
  		it {should be_invalid}
  	end
end
