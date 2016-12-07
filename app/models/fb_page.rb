class FbPage < ActiveRecord::Base
  validates_presence_of :page_id, :post_amount

  def self.to_csv(current_user)
    CSV.generate do |csv|
      csv << ["user_id", "page_id", "post_id", "post_type", "interaction_type", "interaction_subtype"]
      fb_pages = self.all
      fb_pages.each do |fb_page|
        posts = fb_page.get_posts(current_user)
        parsed_posts = JSON.parse(posts.to_json)
        parsed_posts.each do |post|
          post_type = post["type"]
          post_id = post["id"]

         if post_reactions = post["reactions"]
            post_reactions_data = post_reactions["data"]
            post_reactions_data.each do |data|
              user_id = data["id"]
              interaction_subtype = data["type"]
              csv << [user_id, fb_page.page_id, post_id, post_type, "reaction", interaction_subtype]
            end
          end

          if post_comments = post["comments"]
            post_comments_data = post_comments["data"]
            post_comments_data.each do |data|
              from = data["from"]
              user_id = from["id"]
              csv << [user_id, fb_page.page_id, post_id, post_type, "comment"]
            end
          end
        end
      end
    end
  end

  def facebook(current_user)
    @facebook ||= Koala::Facebook::API.new(current_user.oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def get_posts(current_user)
    facebook(current_user).get_connection(page_id, "posts", {limit: post_amount, fields: ["reactions", "type", "comments"] })
  end
end
