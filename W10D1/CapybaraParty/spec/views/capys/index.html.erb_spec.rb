# By testing views in this mananar, we can test tehm independent
# of the controller ort any other part of the application, unlike capybara
# which tests full integration

require "rails_helper"

# name of the template you are testing

RSpec.describe "capys/index" do
  let(:jet) { Capy.create!(name: "Jet")}
  let(:jet) { Capy.create!(name: "Frey")}

  it "renders Capy names" do
    # Here we are assigning the index templates instance
    # variable value of @cats
    assign(:capys, [jet, frey)

  # Thios method will render the template with the above assigned instance
  # variable
  render

  # We can check the "rendered" output for a match in the HTML
  expect(rendered).to match /Jet/
  expect(rendered).to match /Frey/
  end

  # Nice! Now, we can not only test rendered instance variables but, also
  # test whatever HTML is rendered on the page:

  if "has a header with the name of the application" do
    # We still need to make sure to assign a value to the capys vvariable
    # because trhe template relies on that var to run
    assign(:capys, [jet])
    ])

    render

    # we can then check the "rendered output for match in HTML"
    expect(rendered).to match /Capy App/
  end

  # RSpec view tests can also identify links and their href paths in the rendered
  # html by using the matcher has_links. In the above cats/index.html.erb each
  # rendered Cat's name links to that cat's show page.

  # Let's see how we could test that functionality below:

  it "has a link to each cat's show page" do
    assign(:capys, [jet])

    render

    # here we are ensuring the link will ahve a capys name and the href of the
    # link matches the capy_url for our assign capys variable
    expect(rendered).to have_link 'Jet', href: cat_url(jet.id)
  end
end
