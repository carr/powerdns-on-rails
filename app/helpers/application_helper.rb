# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Outputs a page title with +@page_title+ appended
  def page_title
    title = "PowerDNS on Rails"
    title << ' - ' + @page_title unless @page_title.nil?
    title
  end
  
  # Output the flashes if they exist
  def show_flash
    html = ''
    [ :info, :warning, :error ].each do |f|
      options = { :id => "flash-#{f}", :class => "flash-#{f}" }
      options.merge!( :style => 'display:none' ) if flash[f].nil?
      html << content_tag( 'div', options ) { flash[f] || '' }
    end
    html
  end
  
  # Link to Zytrax
  def dns_book( text, link )
    link_to text, "http://www.zytrax.com/books/dns/#{link}", :target => '_blank'
  end
end