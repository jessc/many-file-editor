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

# Search for "keypress" on this file to see how Hackety Hack does copy/paste:
# https://github.com/hacketyhack/hacketyhack/blob/master/app/ui/editor/editor.rb
# Take the relevant code out and apply it to many_file_editor.rb
# This file is now saved as:
# hackey_hack_ui_editor.rb


class ManyFileEditor
  def initialize(foobar)
    main_window(foobar)
  end

  def main_window(foobar)
    s = self
    foobar.app do

      # :alt_v works for alt and command in OS X
      #   :control_v doesn't seem to do anything
      keypress do |key|
        # might be better to use buttons rather than keypresses,
        #   it might be a little clearer because keypresses
        #   are so wonky in Shoes
        # for some reason the first two pastes
        #   work (even if different), but not the third?
        case key
        when :alt_c
          @near_filenames.focus
          self.clipboard = @near_filenames.text
        when :alt_f
          @regex.focus
          self.clipboard = @regex.text
        when :alt_t
          @r_sub.focus
          self.clipboard = @r_sub.text

        when :alt_v
          @near_filenames.focus
          @near_filenames.text = self.clipboard
        when :alt_g
          @regex.focus
          @regex.text = self.clipboard
        when :alt_y
          @r_sub.focus
          @r_sub.text = self.clipboard
        end
      end

      @main_window = 
        # adding ":height => '95%'" on flow and stack causes
        # an infinite scrolling window, which is a bug in Shoes
        flow :margin => 10, :width => '98%' do 
          stack :width => '49%' do

            button "Click for Instructions" do
              @main_window.hide
              @instructions_window = s.instructions_window(foobar)
              @instructions_window.show
            end

            para "Paste Near-Filenames\nwith CMD_V"
            @near_filenames = edit_box do
              @para_near_filenames.text = @near_filenames.text
            end

            # example of how to use .text:
            # para "Folder Location:"
            # @folder_location = edit_line do
            #   @para.text = @folder_location.text
            # end
            # @para = para ""

            button "Choose Folder of Files" do
              @folder_location = ask_open_folder
              @para_folder_loc.text = "Folder Location:\n" + @folder_location
            end
            @para_folder_loc = para ""

            @para_near_filenames = para ""

            # capture near_filenames with regex
            # use Ruby's substitute to change the near_filenames, perhaps?
            # apply regex to @file_list with Ruby's .scan, perhaps?

            # glob the list of files at folder_location
            # @file_list = get_file_list(folder_location)

            # open the files in @file_list

           end
          stack :width => '49%' do
            para "Paste Regex with CMD_G"
            @regex = edit_line
            button "Apply Regex" do; end

            para "Ruby Substitution with CMD_Y"
            @r_sub = edit_line
            button "Apply Substitution" do; end

            para "Fixed Filenames:"
            @filenames_list = edit_box
            button "Open Files" do; end

            button "Editing Window" do
              @main_window.hide
              @editing_window = s.editing_window(foobar)
              @editing_window.show
            end
          end
        end
    end
  end

  def instructions_window(foobar)
    f = nil
    foobar.app do
      f = flow do
        button "Main Window" do
          @instructions_window.hide()
          @main_window.show()
        end
        stack do
          para "Pasting in different places in the same box is unfortunately not supported."
          para "CMD_V: paste to Near Filenames box."
          para "CMD_G: paste to Regex box."
          para "CMD_Y: paste to Ruby Substitution box."
          para "\n"
          para "Copying will copy the entire box, not just the selected text."
          para "CMD_C: copy from Near Filenames box."
          para "CMD_F: copy from Regex box."
          para "CMD_T: copy from Ruby Substitution box."
        end
      end
    end
    f
  end

  def editing_window(foobar)
    f = nil
    foobar.app do
      f = flow do

        para "Editing: <file_name_placeholder>"
        
        file_text = edit_box :margin => 10, :width => '98%', :height => 400 do
        end

        button "Main Window" do
          @editing_window.hide()
          @main_window.show()
        end
        button "Previous File" do; end
        button "Save File" do; end
        button "Next File" do; end

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
