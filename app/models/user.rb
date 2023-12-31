class User < ApplicationRecord
  attr_accessor :preferences_hash

  before_validation do |user|
    user.preferences = JSON.generate(user.preferences_hash)
  end

  after_initialize do |user|
    user.preferences_hash = begin
                              JSON.parse(preferences, symbolize_names: true)
                            rescue StandardError => e
                              User.default_preferences
                            end
  end

  after_commit do |user|
    user.check_bio_for_tos
    user.email_that_user_info_changed
  end

  validates_presence_of((column_names - %w[created_at updated_at id])) # all column names
  validates_length_of :display_name, :minimum => 3, :maximum => 3
  validates_length_of :bio, :minimum => 20
  validates_uniqueness_of :email
  validates_numericality_of :age
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :text_must_be_decent
  validate :preferences_hash_and_schema
  validate :state_is_accepted

  enum :sex => %i[male female]

  def text_must_be_decent
    if (['list of bad names'] * 30).include?(display_name)
      errors.add(:display_name, 'Wash your mouth out with soap!')
    end
  end

  def preferences_hash_and_schema
    required_keys = User.default_preferences.keys
    required_keys.each do |key|
      unless preferences_hash.key?(key)
        errors.add(key, "#{key} is missing in preferences hash")
      end
    end

    self.preferences = JSON.generate(preferences_hash)
  end

  def state_is_accepted
    unless ['NY', 'CO', 'CA', 'MA'].include?(state)
      errors.add(:state, "#{state} is not valid!")
    end
  end

  def check_bio_for_tos
    pp 'Call some active job that inputs the users bio into a machine learning service that makes sure there is not profanity, weird links, or other terms of service violations'
  end

  def email_that_user_info_changed
    pp 'emailing user that his information got updated'
  end

  def self.default_preferences
    {
      dark_mode: true,
      reduce_animations: false,
      stop_cookies: false,
      high_contrast: false,
      no_javascript: false,
      private_usage: true
    }
  end
end
