require 'spec_helper'

describe "/connection_links/show", :type => :view do
  
  assign_referential
  let!(:connection_link) { assign(:connection_link, create(:connection_link)) }
  let!(:map) { assign(:map, double(:to_html => '<div id="map"/>'.html_safe)) }

  it "should render h2 with the connection_link name" do
    render
    expect(rendered).to have_selector("h2", :text => Regexp.new(connection_link.name))
  end

#  it "should display a map with class 'connection_link'" do
#    pending ": map not yet implemented"
#     render
#     rendered.should have_selector("#map", :class => 'connection_link')
#  end

  it "should render a link to edit the connection_link" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.edit_referential_connection_link_path(referential, connection_link)}']")
  end

  it "should render a link to remove the connection_link" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{view.referential_connection_link_path(referential, connection_link)}'][class='remove']")
  end

end

