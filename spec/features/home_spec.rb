feature "homepage" do
  scenario "visitor visits homepage" do
    visit "/"

    expect(page).to have_link("Register")
  end
end