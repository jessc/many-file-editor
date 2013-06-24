#!/usr/bin/env ruby

# 2013-06
# Jesse Cummins
# https://github.com/jessc
# With inspiration from ashbb:
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
        flow :margin => 10, :width => '98%' do 
          stack :width => '49%' do

            button "Choose Folder with Files" do
              @folder_location = ask_open_folder
              @para_folder_loc.text = @folder_location
            end

            para "Near-Filenames:"
            flow do
              button "Copy" do
                self.clipboard = @near_filenames.text
              end
              button "Paste" do
                @near_filenames.text = self.clipboard
              end
            end
            @near_filenames = edit_box

            @para_folder_loc = para "\n"
          end

          # example of how to use .text:
          # @folder_location = edit_line do
          #   @para.text = @folder_location.text
          # end
          # @para = para ""


          # capture near_filenames with regex
          # use Ruby's substitute to change the near_filenames, perhaps?
          # apply regex to @file_list with Ruby's .scan, perhaps?

          # open the files in @file_list

          stack :width => '49%' do
            para "Regex:"
            button "Apply Regex" do; end
            @regex = edit_line

            para "\nRuby Substitution:"
            flow do
              button "Copy" do
                self.clipboard = @r_sub.text
              end
              button "Paste" do
                @r_sub.text = self.clipboard
              end
              button "Apply" do; end
            end
            @r_sub = edit_line

            para "\nFixed Filenames:"
            button "Paste" do
              @filenames_list.text = self.clipboard
            end
            
            # button "Get File Names" do
            button "Short File Names" do
              @shortnames_files = s.get_file_list(long_path = false)
              @filenames_list.text = ""
              @shortnames_files.each { |file| @filenames_list.text += file + "\n" }
            end

            # button "Open Files" do
            button "Long File Names" do
              @longnames_files = s.get_file_list(long_path = true)
              @filenames_list.text = ""
              @longnames_files.each { |file| @filenames_list.text += file + "\n" }
              # open editing window, start with first file
            end
            @filenames_list = edit_box

            # delete this button eventually
            button "Editing Window" do
              @main_window.hide
              @editing_window = s.editing_window(foobar)
              @editing_window.show
            end
            button "Quit App" do
              quit
            end
          end
        end
    end
  end

  def editing_window(foobar)
    # open in write mode each file in @file_list
    # one by one editing each

    # file_list = @shortnames_files

    file_list = ["/first/file_name", "/second/file_name", "/third/file_name"]

    # perhaps in file_text start with first file in file_list
    # @file_list.each { |file| puts File.read(dirname + file) }

    f = nil
    foobar.app do
      f = flow do
        
        cur_file_num = 0
        # add @ to front of file_list
        current_file = para "Editing: " + file_list[cur_file_num]

        file_text = edit_box :margin => 10, :width => '98%', :height => 400 do
        end
        # add @ to front of file_list
        file_text.text = file_list[cur_file_num]

        button "Quit App" do
          quit
        end
        button "Main Window" do
          @editing_window.hide()
          @main_window.show()
        end
        button "Previous File" do
          cur_file_num -= 1 unless cur_file_num == 0
          # add @ to front of file_list
          current_file.text = "Editing: " + file_list[cur_file_num]
          file_text.text = file_list[cur_file_num]
        end
        button "Save File" do; end
        button "Next File" do
          # add @ to front of file_list
          cur_file_num += 1 unless cur_file_num > file_list.length
          current_file.text = "Editing: " + file_list[cur_file_num]
          file_text.text = file_list[cur_file_num]
        end
      end
    end
    f
  end

  def get_file_list(long_path = false)
    f_l = @folder_location
    unless f_l != nil
      f_l = "/Users/jessc/Documents/Dropbox/leaf/useful/code/many-file-editor/file_examples/"
    end
    @file_list = Dir.entries(f_l).select { |f| File.file?(f_l + "#{f}") }
    if long_path
      @file_list.map! { |f| f = f_l + "#{f}" }
    end
    @file_list
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
