class Tweeter < ActiveRecord::Base

  # For users that follow the current tweeter
  has_many :follower_relationships, class_name: "Relationships", foreign_key: "followee_id"


  def self.client
    @client ||= Twitter::REST::Client.new do |config|
      tweet_config = TwitterSocialNavigator::Config["twitter"]
      config.consumer_key        = tweet_config["api_key"]
      config.consumer_secret     = tweet_config["api_secret"]
      config.access_token        = tweet_config["access_token"]
      config.access_token_secret = tweet_config["access_token_secret"]
    end
  end

  def get_followers
    puts "Getting followers for #{handle}"

    cursor = nil

    begin
      cursor = Tweeter.client.follower_ids("#{handle}")
    rescue Twitter::Error::TooManyRequests => e
      puts "HIT RATE LIMIT - WAITING"
      sleep(60*15)
      cursor = Tweeter.client.follower_ids("#{handle}")
    end


    begin
      ids = cursor.attrs[:ids]
      puts "Found the following users " + ids.to_s
      keep_going = false
      if cursor.send(:last?) == false
        keep_going = true
        begin
          cursor.send(:fetch_next_page)
        rescue Twitter::Error::TooManyRequests => e
          puts "HIT RATE LIMIT - WAITING"
          sleep(60*15)
          cursor.send(:fetch_next_page)
        end
      end
    end while (keep_going == true)



  end
end
