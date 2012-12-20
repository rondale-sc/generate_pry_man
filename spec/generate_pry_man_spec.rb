require_relative "../generate_pry_man.rb"
require 'tempfile'

describe GeneratePryMan do

  let(:tmp_html) { Tempfile.new('man-html') }
  let(:tmp_roff) { Tempfile.new('man-roff') }
  let(:tmp_ronn) { Tempfile.new('man-ronn') }
  let(:man_sections) do
    { authors:      "Fred Flintstone",
      description:  "Does stuff.",
      examples:     "Look at me do stuff.",
      files:        "Here are some places to look on your system",
      homepage:     "Here are some places to look on the intrawebz",
      options:      "Here are some of my cool options",
      pry_commands: "Some commands."}
  end

  let(:gpm) do
     GeneratePryMan.new({ man_sections: man_sections,
       ronn_file:    tmp_ronn,
       html_file:    tmp_html,
       roff_file:    tmp_roff })
  end

  it "generates a proper man-page roff file" do
    test_roff = File.read(File.expand_path(File.join(__FILE__, "..", "..",  "ext", "test.roff")))
    gpm.ronn_to_roff
    File.read(tmp_roff.path).should eql(test_roff)
  end

  it "generates a proper man-page html file" do
    test_html = File.read(File.expand_path(File.join(__FILE__, "..", "..",  "ext", "test.html")))
    gpm.ronn_to_html
    File.read(tmp_html.path).should eql(test_html)
  end
end
