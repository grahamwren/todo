# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#


class User < ApplicationRecord
  has_secure_password

  def as_json(options = {})
    super(options.merge({ except: %i[password password_digest] }))
  end
end
