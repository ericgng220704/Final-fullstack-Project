require 'rails_helper'

RSpec.describe "User Authentication", type: :feature do
  it "allows a user to sign up, login, and logout" do
    visit new_user_registration_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content "Welcome"
    click_link "Logout"
    expect(page).to have_content "Login"
  end
end
