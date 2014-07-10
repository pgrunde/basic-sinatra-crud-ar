feature "homepage" do
  before(:each) do
    visit "/"
  end
  scenario "visitor visits homepage" do
    skip
    expect(page).to have_link("Register")
  end

  scenario "visit registeration page" do
    skip
    click_link "Register"
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    expect(page).to have_button("Submit")
  end

  scenario "register new user" do
    skip
    click_link "Register"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Submit"
    expect(page).to have_content("Thank you for registering")
  end

  scenario "log in user" do
    skip
    click_link "Register"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Submit"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    #save_and_open_page
    expect(page).to have_content("Welcome, peter")
  end

  scenario "logout user" do
    skip
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link "Logout"
    expect(page).to have_link("Register")
  end

  scenario "login validation" do
    skip
    click_link "Register"
    click_button "Submit"
    expect(page).to have_content("Please enter a username and password.")
    fill_in "username", :with => "peter"
    click_button "Submit"
    expect(page).to have_content("Please enter a password.")
    fill_in "username", :with => ""
    fill_in "password", :with => "luke"
    click_button "Submit"
    expect(page).to have_content("Please enter a username.")
  end

  scenario "see usernames on login" do
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    expect(page).to have_content("Welcome, peter lindsay")
  end
end