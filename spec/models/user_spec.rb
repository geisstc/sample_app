require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com")
    @user.password = "foobar"
    @user.password_confirmation= "foobar"
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  #6.3.3 autenticate users
  it {should respond_to (:authenticate)}

  it { should be_valid }
       # test for if a blank is not valid
  describe "when name is not present" do
    before {@user.name = ""}
    it {should_not be_valid}

  end
  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end
  #length validation
  describe "when name is too long" do
    before {@user.name = "a" * 51}
    it {should_not be_valid}
  end
#EMAIL TESTS
#test for email being invalid using bad email addresses
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
     end
    end
  end
 #formets for which the test will pass - just a few
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      #create a user with teh same email address @user.dup
      # + tests the uppercase tries to save it uppercase should be the
      #also duplicate.
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it {should_not be_valid}
  end
#PASSWORD TESTS & CONFIRMATION
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com")
      @user.password = " "
      @user.password_confirmation = " "
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
 #PASSWORD AUTHENTICATION AND LOGIN ALLOWANCE
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  # finds a user using let and checks if passwords (user.password)
  #matches the email needed
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
  #authenticate method on the password to the email
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end

