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
        # adding ":height => '95%'" on flow and stack causes
        # an infinite scrolling window, which is a bug in Shoes
        flow :margin => 10, :width => '96%' do 
          stack :width => '48%' do
            para "Paste Near-Filenames Here"
            @near_filenames = edit_box

            # example of how to use .text:
            # para "Folder Location"
            # @folder_location = edit_line do
            #   @para.text = @folder_location.text
            # end
            # @para = para ""


            button "Choose Folder" do
              folder = ask_open_folder
              # for some reason this is showing at the top of the window
              # rather than underneath the button
              para folder
            end

            para "Folder Location:"

            # apply regex to @file_list inplace

            # glob the list of files at folder_location
            # @file_list = get_file_list(folder_location)

            # open the files in @file_list

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

  def get_file_list(folder_location)
    # this is some unchanged code from a previous project that
    # may help with getting the files from the folder_location
    @file_list = []
    path = folder_location
    if path.end_with? "/" then path += "**/*"
    else path += "/**/*"
    end
    @file_list << Dir.glob(path)
    @file_list.flatten!
  end

end

Shoes.app :title => "Many File Editor" do
  @many_file_editor = ManyFileEditor.new(self)
end



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
