# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    counter = Count.first
    if counter.nil?
      counter = Count.create!
    end

    counter.user_count += 1
    counter.save!
    render :home, locals: { counter: counter }
  end
end
