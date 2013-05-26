#!/usr/bin/env ruby

# 2013-05
# Jesse Cummins
# https://github.com/jessc


Shoes.app :title => "Many File Editor" do
  stack do
    button "Get File" do
      filename = ask_open_file
      edit_box File.read(filename)
    end
  end
end

=begin

- button to open text file, put in edit box
  - select filenames inside to open later
    - copy and paste them into another edit box on the right
  - modify filenames according to rules
- close main file
- open each filename
  - edit box, previous/next/save buttons
  - make sure Unicode works
  - next closes file, opens next
- exit button closes app

=end
