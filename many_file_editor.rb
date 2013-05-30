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
 flow :width => '100%', :height => '100%', :margin => 10 do
    stack :width => '48%', :height => '100%' do
      para "Paste Near-Filenames Here"
      @near_filenames = edit_box.text
      para "Folder Location"
      @folder_location = edit_line.text
      # glob the list of files at folder_location
      # later open the files that match the regex
     end
    stack :width => '48%', :height => '100%' do
      para "Place Regex Here"
      @regex = edit_line.text
      button "Apply Regex" do
      end
      @filenames_list = edit_box.text
      button "Open Files" do
      end
    end
  end
end

# Shoes.app :title => "Many File Editor" do
#   button("Hide Window") do
#     @window_slot.toggle
#   end
#   @window_slot = flow :width => '100%', :height => '100%', :margin => 10 do
#     stack :width => '48%', :height => '100%' do
#       para "Get the file with the file names."
#       button "Get File" do
#         filename = ask_open_file
#         @left_box.text = File.read(filename)
#       end
#       @left_box = edit_box :width => '95%', :height => '85%'
#     end
#     stack :width => '48%', :height => '100%' do
#       para "Move list of file names here."
#       button "Next Step"
#       @right_box = edit_box :width => '95%', :height => '85%'
#     end
#   end
# end


=begin

- put list of near-filenames in edit box
- have a line for a regex to be run on the near-filenames, with an apply button
- apply regex on each line, which outputs to the edit box to the right
- clear window
- open each filename
  - edit box, previous/next/save buttons
  - make sure Unicode works
  - previous/next closes file, opens previous/next
- exit button closes app


=end
