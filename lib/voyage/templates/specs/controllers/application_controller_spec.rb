require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  controller do
    skip_authorization_check only: :show

    def index
      raise CanCan::AccessDenied
    end

    def show
      render body: 'show called'
    end
  end

  context 'errors' do
    it 'rescues from cancan errors and redirects' do
      sign_in(user)
      get :index
      expect(response).to be_redirect
    end
  end

  context 'analytics' do
    before do
      allow(user).to receive(:tester?).and_return(false)
      allow(Analytics).to receive(:track)
    end

    it 'tracks with some global defaults' do
      controller.analytics_track(user, 'Signed In', page_name: 'Page')
      expect(Analytics).to have_received(:track)
    end

    it 'trys to pull roles on a non-user object' do
      allow(user).to receive(:roles).and_return(StandardError.new('bazinga'))
      controller.analytics_track(user, 'Signed In', page_name: 'Page')
      expect(Analytics).to have_received(:track)
    end
  end

  context 'variants' do
    it 'allows iPad variants' do
      request.env['HTTP_USER_AGENT'] = 'iPad'
      sign_in(user)
      get :show, params: { id: 'anyid' }
      expect(request.variant).to include(:tablet)
    end

    it 'allows iPhone variants' do
      request.env['HTTP_USER_AGENT'] = 'iPhone'
      sign_in(user)
      get :show, params: { id: 'anyid' }
      expect(request.variant).to include(:phone)
    end

    it 'allows Android phone variants' do
      request.env['HTTP_USER_AGENT'] = 'Android mobile'
      sign_in(user)
      get :show, params: { id: 'anyid' }
      expect(request.variant).to include(:phone)
    end

    it 'allows Android tablet variants' do
      request.env['HTTP_USER_AGENT'] = 'Android'
      sign_in(user)
      get :show, params: { id: 'anyid' }
      expect(request.variant).to include(:tablet)
    end

    it 'allows Windows phone variants' do
      request.env['HTTP_USER_AGENT'] = 'Windows Phone'
      sign_in(user)
      get :show, params: { id: 'anyid' }
      expect(request.variant).to include(:phone)
    end
  end
end
