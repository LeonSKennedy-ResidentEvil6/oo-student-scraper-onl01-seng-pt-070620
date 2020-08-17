require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper


  def self.scrape_index_page(index_url)

    scraped_students = []

    doc = Nokogiri::HTML.parse(open(index_url))

    doc.css("div.student-card").each do |student|
      student_profile = {}
      student_profile[:name] = student.css("h4.student-name").text
      student_profile[:location] = student.css("p.student-location").text
      student_profile_url = student.css("a").attribute("href").value
      student_profile[:profile_url] = student_profile_url
      scraped_students << student_profile
    end
    scraped_students
  end




  def self.scrape_profile_page(profile_url)
    # create am empty hash to store keys/values of each student social profile
    scraped_student = {}
    # scrap student's profile page
    html = Nokogiri::HTML.parse(open(profile_url))
    # scrap each different social media link if there is one
    social_link = html.css("div.main-wrapper.profile").css("div.vitals-container").css("div.social-icon-container a").css("a").each do |social|
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


    scraped_student[:profile_quote] = html.css("div.main-wrapper.profile").css("div.vitals-container").css("div.profile-quote").text
    scraped_student[:bio] = html.css("div.main-wrapper.profile").css("div.details-container").css("div.description-holder").css("p").text

    scraped_student
    
  end

end
