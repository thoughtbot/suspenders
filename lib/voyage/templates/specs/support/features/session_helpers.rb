module Features
  module SessionHelpers
    def sign_in(email, password)
      visit sign_in_path
      within '.form-inputs' do
        fill_in 'user_email', with: email
        fill_in 'user_password', with: password
      end

      click_button 'Log in'
    end

    def sign_up_with(first, last, email, password, password_confirmation)
      visit new_user_registration_path
      within '.form-inputs' do
        fill_in 'First name', with: first
        fill_in 'Last name', with: last

        fill_in 'Email', with: email
        fill_in 'user_password', with: password
        fill_in 'user_password_confirmation', with: password_confirmation
      end

      click_button 'Sign up'
    end
  end
end
