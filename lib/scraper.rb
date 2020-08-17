require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper


  # def self.scrape_index_page(index_url)
  #   scraped_students = []
  #   html = open(index_url)
  #   doc = Nokogiri::HTML(html)
  #
  #   doc.css("div.student-card").each do |student|
  #     student_profile = {}
  #     student_profile[:name] = student.css("h4.student-name").text
  #     student_profile[:location] = student.css("p.student-location").text
  #     student_profile_url = student.css("a").attribute("href").value
  #     student_profile[:profile_url] = student_profile_url
  #     scraped_students << student_profile
  #   end
  #   student
  # end


  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    index = Nokogiri::HTML(html)
    index.css("div.student-card").each do |student|
      student_details = {}
      student_details[:name] = student.css("h4.student-name").text
      student_details[:location] = student.css("p.student-location").text
      profile_path = student.css("a").attribute("href").value
      student_details[:profile_url] = './fixtures/student-site/' + profile_path
      students << student_details
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    # create am empty hash to store keys/values of each student social profile
    scraped_student = {}
    # scrap student's profile page
    html = Nokogiri::HTML(open(profile_url))
    social_link = html.css("div.main-wrapper.profile").css("div.rvitals-container").css("div.social-icon-container").css("a")
    # scrap each different social media link if there is one
    social_link.each do |social|
      if social.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        scraped_student[:github] = social.attribute("href").value
      else
        scraped_student[:blog] = social.attribute("href").value
      end
    end

    scraped_student[:profile_quote] = social_link.css("div.main-wrapper.profile").css("div.details-container").css("div.bio-content.content-holder").text
    scraped_student[:bio] = social_link.css("div.main-wrapper.profile").css("div.details-container").css("div.profile-quote").text

    scraped_student
  end

end

Scraper.new.scrape_index_page
