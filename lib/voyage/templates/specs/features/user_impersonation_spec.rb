require 'rails_helper'

feature 'Impersonate user' do
  given(:admin_user) { create(:user, :admin) }
  given(:regular_user) { create(:user) }

  scenario 'With admin privileges' do
    sign_in(admin_user.email, admin_user.password)

    visit impersonate_admin_user_path(id: regular_user.id)

    expect(page).to have_content('Stop Impersonating')
  end

  scenario 'With admin privileges: End Impersonation' do
    sign_in(admin_user.email, admin_user.password)

    visit impersonate_admin_user_path(id: regular_user.id)
    visit stop_impersonating_admin_users_path

    expect(page).to_not have_content('Stop Impersonating')
  end

  scenario 'Without admin privileges' do
    sign_in(regular_user.email, regular_user.password)

    visit impersonate_admin_user_path(id: admin_user.id)

    expect(page).to have_content('You must be an admin to perform that action')
  end

  scenario 'Stop impersonating when not impersonating' do
    visit stop_impersonating_admin_users_path

    expect(page)
      .to have_content('You need to sign in or sign up before continuing.')
  end
end
