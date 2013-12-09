Then(/^I should see all events sorted in (.*) order$/) do |order_type|
  
  names = Nokogiri::HTML.parse(page.body).css('tr td:nth-child(1)').to_a.map{ |td| td.text }
  a = Array.new
  Event.all.each  do |event|
      a << event.name
  end 
  b = Array.new
  Event.page(1).per(10).all.each do |e|
    b << e.name
  end

  case order_type
  when 'ascending'
  	expected_names = Event.order('name ASC').map(&:name)
    assert a[0..9]== b
  when 'descending'
  	expected_names = Event.order('name DESC').map(&:name)
    names.each{ |name|
    assert names.index(name) == expected_names.index(name)
    }
  end
end

When(/^I sort by name$/) do
  page.execute_script("$('th.header:nth-child(1)').click()")
end
