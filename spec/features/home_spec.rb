feature "homepage" do
  before(:each) do
    visit "/"
  end
  scenario "visitor visits homepage" do
    expect(page).to have_link("Register")
  end

  scenario "visit registeration page" do
    click_link "Register"
    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
    expect(page).to have_button("Register")
  end

  scenario "register new user" do
    click_link "Register"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Register"
    expect(page).to have_content("Thank you for registering")
  end
end

feature "register" do
  before(:each) do
    visit "/register/"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Register"
  end
  scenario "log in user" do
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    expect(page).to have_content("Welcome, peter")
  end

  scenario "logout user" do
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link "Logout"
    expect(page).to have_link("Register")
  end

  scenario "register validation" do
    click_link "Register"
    click_button "Register"
    expect(page).to have_content("Please enter a username and password.")
    fill_in "username", :with => "peter"
    click_button "Register"
    expect(page).to have_content("Please enter a password.")
    fill_in "username", :with => ""
    fill_in "password", :with => "luke"
    click_button "Register"
    expect(page).to have_content("Please enter a username.")
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Register"
    expect(page).to have_content("That name is taken.")
  end
end

feature "many users" do
  before(:each) do
    visit "/register/"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Register"
    visit "/register/"
    fill_in "username", :with => "lindsay"
    fill_in "password", :with => "luke"
    click_button "Register"
    visit "/register/"
    fill_in "username", :with => "jeff"
    fill_in "password", :with => "luke"
    click_button "Register"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
  end

  scenario "see usernames on login" do
    expect(page).to have_content("lindsay Delete jeff")
  end

  scenario "click sort button to alphabetize users" do
    click_button "Sort"
    expect(page).to have_content("jeff Delete lindsay")
    select 'desc', from: 'sort'
    click_button "Sort"
    expect(page).to have_content("lindsay Delete jeff")
  end

  scenario "deletes users successfully" do
    click_button("delete_jeff")
    expect(page).to have_no_content("jeff")
  end

  scenario "adds fish to fish table" do
    click_link("Create Fish")
    fill_in "name", :with => "fur-bearing trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Fur-bearing_trout"
    click_button "Create"
    expect(page).to have_link("Wiki", :href => "http://en.wikipedia.org/wiki/Fur-bearing_trout")
  end

  scenario "user only sees user fish" do
    click_link("Create Fish")
    fill_in "name", :with => "fur-bearing trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Fur-bearing_trout"
    click_button "Create"
    click_link "Logout"
    fill_in "username", :with => "lindsay"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link("Create Fish")
    fill_in "name", :with => "Salmon of Knowledge"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Salmon_of_Knowledge"
    click_button "Create"
    expect(page).to have_link("Wiki", :href => "http://en.wikipedia.org/wiki/Salmon_of_Knowledge")
    expect(page).to have_no_content("fur-bearing trout")
  end

  scenario "click on a user in the list to see their fish" do
    click_link("Create Fish")
    fill_in "name", :with => "fur-bearing trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Fur-bearing_trout"
    click_button "Create"
    click_link "Logout"
    fill_in "username", :with => "lindsay"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link "peter"
    expect(page).to have_link("fur-bearing trout", :href => "http://en.wikipedia.org/wiki/Fur-bearing_trout")
  end
end

feature "complex number of users and fish" do
  before(:each) do
    visit "/register/"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Register"
    visit "/register/"
    fill_in "username", :with => "lindsay"
    fill_in "password", :with => "luke"
    click_button "Register"
    visit "/register/"
    fill_in "username", :with => "jeff"
    fill_in "password", :with => "luke"
    click_button "Register"
    fill_in "username", :with => "peter"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link "Create Fish"
    fill_in "name", :with => "fur-bearing trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Fur-bearing_trout"
    click_button "Create"
    click_link "Logout"
    fill_in "username", :with => "lindsay"
    fill_in "password", :with => "luke"
    click_button "Log In"
    click_link("Create Fish")
    fill_in "name", :with => "Salmon of Knowledge"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Salmon_of_Knowledge"
    click_button "Create"
  end

  scenario "click to favorite/unfavorite peter's fish from lindsay's account" do
    click_link "peter"
    click_link "fav"
    expect(page).to have_content("unfav")
    click_button "unfav_fur-bearing trout"
    expect(page).to have_content("fav")
  end

  scenario "delete my own fish" do
    click_button "delete_Salmon of Knowledge"
    expect(page).to_not have_content("Salmon of Knowledge")
  end

  scenario "search fish" do

    click_link("Create Fish")
    fill_in "name", :with => "brown trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Brown_trout"
    click_button "Create"

    click_link("Create Fish")
    fill_in "name", :with => "rainbow trout"
    fill_in "wiki", :with => "http://en.wikipedia.org/wiki/Rainbow_trout"
    click_button "Create"

    click_link("Search Fish")
    fill_in("fish_name", :with => "trout")
    click_button("Search")
    expect(page).to have_content("fur-bearing trout")
    expect(page).to have_content("rainbow trout")
    expect(page).to have_content("brown trout")
    expect(page).to_not have_content("Salmon of Knowledge")

  end

end