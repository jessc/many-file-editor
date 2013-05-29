#!/usr/bin/env ruby

# 2013-05
# Jesse Cummins
# https://github.com/jessc

=begin
# Bug List:

- why isn't copy/paste working from one edit box to another?

# TODO:
=end


Shoes.app :title => "Many File Editor" do
  button("Hide Window") do
    @window_slot.toggle
  end
  @window_slot = flow :width => '100%', :height => '100%', :margin => 10 do
    stack :width => '48%', :height => '100%' do
      para "Get the file with the file names."
      button "Get File" do
        filename = ask_open_file
        @left_box.text = File.read(filename)
      end
      @left_box = edit_box :width => '95%', :height => '85%'
    end
    stack :width => '48%', :height => '100%' do
      para "Move list of file names here."
      button "Next Step"
      @right_box = edit_box :width => '95%', :height => '85%'
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
