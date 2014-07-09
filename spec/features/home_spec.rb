feature "homepage" do
  before(:each) do
    visit "/"
  end
  scenario "visitor visits homepage" do
    expect(page).to have_link("Register")
  end

  scenario "visit registeration page" do
    click_link "Register"
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    expect(page).to have_button("Submit")
  end
end