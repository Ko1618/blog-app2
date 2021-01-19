# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorite_articles, through: :likes, source: :article
  #has_many :articles, through: :likesでも可

  delegate :birthday, :age, :gender, to: :profile, allow_nil: true
  #def birthday
  #  profile&.birthday
  #end

  #def gender
  #  profile&.gender
  #end

  def has_written?(article)
    articles.exists?(id: article.id)
  end

  def has_liked?(article)
    likes.exists?(article_id: article.id)
  end

  def display_name
    #if profile && profile.nickname
    # profile.nickname
    #else
    # self.email.split('@').first
    #end

    #ボッチ演算子（profileがnilじゃないときnicknameを実行)
    profile&.nickname || self.email.split('@').first
    #first = [0]も可
  end

  def prepare_profile
    profile || build_profile
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end
end
