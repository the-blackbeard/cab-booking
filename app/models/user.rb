class User < ApplicationRecord
  has_many :cab_bookings

  validates_presence_of :first_name, :last_name, :email, :lat, :long, :role
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  enum role: [:rider, :driver]
end
