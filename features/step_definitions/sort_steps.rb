Then(/^I should see all events sorted in (.*) order$/) do |order_type|
  
  case order_type
  when 'ascending'
  	expected_names = Event.order('name ASC').map(&:name)
  when 'descending'
  	expected_names = Event.order('name DESC').map(&:name)
  end

  names = Nokogiri::HTML.parse(page.body).css('tr td:nth-child(1)').to_a.map{ |td| td.text }
  names.each{ |name|
  	assert names.index(name) == expected_names.index(name)
  }
end



When(/^I sort by name$/) do
  page.execute_script("$('th.header:nth-child(1)').click()")
end
