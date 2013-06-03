#!/usr/bin/env ruby

# 2013-06
# Jesse Cummins
# https://github.com/jessc
# With Shoes inspiration from Dan Garland:
# https://github.com/dmgarland/TrafficLight
# And inspiration from ashbb:
# https://github.com/shoes/shoes/issues/236#issuecomment-18843728

=begin
# Bug List:
# TODO:
=end


class ManyFileEditor
  def initialize(foobar)
    main_window(foobar)
  end

  def main_window(foobar)
    s = self
    foobar.app do
      @main_window = 
        # why with ":height => '95%'" on flow and stack doesn't it work?
        flow :margin => 10, :width => '96%' do 
          stack :width => '48%' do
            para "Paste Near-Filenames Here"
            @near_filenames = edit_box.text
            para "Folder Location"
            @folder_location = edit_line.text
            # glob the list of files at folder_location
            # later open the files that match the regex
           end
          stack :width => '48%' do
            para "Place Regex Here"
            @regex = edit_line.text
            button "Apply Regex" do; end
            @filenames_list = edit_box.text
            button "Open Files" do; end
            button "Editing Window" do
              @main_window.hide()
              @editing_window = s.editing_window(foobar)
              @editing_window.show()
            end
          end
        end
    end
  end

  def editing_window(foobar)
    f = nil
    foobar.app do
      f = flow do
        button "Main Window" do
          @editing_window.hide()
          @main_window.show()
        end
      end
    end
    f
  end
end

Shoes.app :title => "Many File Editor" do
  @many_file_editor = ManyFileEditor.new(self)
end



# placeholder stuff:
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
