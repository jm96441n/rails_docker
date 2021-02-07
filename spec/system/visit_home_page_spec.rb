# frozen_string_literal: true

require 'rails_helper'

describe 'visit home page' do
  it 'shows the welcome page' do
    visit '/'
    expect(page).to have_content('Hello There')
  end

  it 'increments the counter on each visit' do
    visit '/'
    expect(page).to have_content("You're the 1st")

    visit '/'
    expect(page).to have_content("You're the 2nd")
  end
end
