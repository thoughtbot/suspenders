require 'rails_helper'

feature 'User signup' do
  scenario 'Valid user information' do
    sign_up_with('First', 'Last', 'test@example.com', 'password', 'password')
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'Passwords do not  match' do
    sign_up_with('First', 'Last', 'test@example.com', 'password', 'password2')
    expect(page).to have_content("doesn't match Password")
  end

  scenario 'Email is invalid' do
    sign_up_with('First', 'Last', 'test2example.com', 'password', 'password')
    expect(page).to have_content('is invalid')
  end
end
