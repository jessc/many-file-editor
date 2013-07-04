#!/usr/bin/env ruby

# 2013-07
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

            para "Near-Filenames:"
            @near_filenames = edit_box :width => '90%', :height => 150
            flow do
              button "Copy" do
                self.clipboard = @near_filenames.text
              end
              button "Paste" do
                @near_filenames.text = self.clipboard
              end
              button "Open File" do
                filename = ask_open_file
                @near_filenames.text = File.read(filename)
              end
            end

            para "Regex:"
            @regex = edit_line
            @regex.text = '(bk_\w+)'
            flow do
              button "Copy" do
                self.clipboard = @regex.text
              end
              button "Paste" do
                @regex.text = self.clipboard
              end
              button "Apply" do
                if @near_filenames.text
                  regex_to_use = Regexp.new @regex.text
                  applied_regex = @near_filenames.text.scan(regex_to_use).flatten
                  caught_filenames = ""
                  applied_regex.each { |file| caught_filenames += file + "\n" }
                  @fixed_files_box.text = caught_filenames
                end
              end
            end

            para "Add File Extension:"
            # bug:
            # perhaps add copy/paste buttons
            @file_extension = edit_line
            applied_already = false
            button "Apply" do
              unless @file_extension.text == "" || applied_already
                extension = @file_extension.text
                old_text = @fixed_files_box.text

                # bug:
                # use .map! here to edit lines inplace
                replacement_text = ""
                old_text.each_line { |line| replacement_text += line.chomp + extension + "\n" }
                @fixed_files_box.text = replacement_text
                # bug:
                # when switching back to the main window from the edit window,
                # turn applied_already back to false
                applied_already = true
              end
            end
          end
          
          stack :width => '49%' do

            button "Choose Location of Files" do
              @folder_location = ask_open_folder + "/"
              @para_folder_loc.text = @folder_location
            end
            @para_folder_loc = para "No folder chosen yet.\n", :size => 8

            stack do
              para "Fixed Names:"
              @fixed_files_box = edit_box :width => '90%', :height => 275
            end

            flow do
              button "Open Files" do
                if @fixed_files_box.text != ""
                  f_l = @folder_location
                  fixed = @fixed_files_box.text.split("\n")
                  @names_files = {}
                  @names_files[:short] = fixed
                  @names_files[:long] = fixed.map { |line| line = f_l + line }

                  # bug:
                  # Figure out why when the @main_window is hidden,
                  # the @names_files variable becomes nil or "".
                  # One way to get around this is to pass in
                  # the variables to the window, but this seems hackish

                  # bug:
                  # DRY this switch_window code into a method
                  @main_window.hide
                  @editing_window = s.editing_window(foobar, @names_files)
                  @editing_window.show
                end
              end
              # bug:
              # add Copy button too
              button "Paste" do
                @fixed_files_box.text = self.clipboard
              end
            end
            button "Clear Program" do
              @near_filenames.text = ""
              @regex.text = '(bk_\w+)'
              # bug:
              # when @names_files is cleared and Open Files button is pressed,
              # the Editing Window is blank
              @names_files = {}
              @fixed_files_box.text = ""
              @file_extension.text = ""
            end
            button "Quit App", {:right => 0, :bottom => 0} do
              quit
            end
          end
        end
    end
  end

  def editing_window(foobar, names_files)
    # bug:
    # Why is @names_files not being sent across methods?
    # file_list = @names_files

    long_file_list = names_files[:long]
    file_list = names_files[:short]

    f = nil
    foobar.app do
      f = flow do
        
        cur_file_num = 0
        current_file_name = para "Editing: " + file_list[cur_file_num]
        file_saved = para "", :size => 8

        # bug:
        # check that this edit_box will load/save
        # correctly with UTF-8 characters
        file_text = edit_box :margin => 10, :width => '98%', :height => 400 do
        end
        current_file_long_name = long_file_list[cur_file_num]
        cur_file = File.open(current_file_long_name, mode="r+")
        file_text.text = cur_file.read

        button "Quit App" do
          quit
        end
        button "Main Window" do
          @editing_window.hide()
          @main_window.show()
        end
        # bug:
        # DRY this code
        button "Save File" do
          cur_file = File.open(current_file_long_name, mode="w")
          cur_file.write(file_text.text)
          cur_file.close
          cur_file = File.open(current_file_long_name, mode="r+")
          file_saved.text = "     File Saved"
        end
        button "Previous File" do
          file_saved.text = ""
          cur_file_num -= 1 unless cur_file_num == 0
          current_file_name.text = "Editing: " + file_list[cur_file_num]
          current_file_long_name = long_file_list[cur_file_num]
          cur_file = File.open(current_file_long_name, mode="r+")
          file_text.text = cur_file.read
        end
        button "Next File" do
          file_saved.text = ""
          cur_file_num += 1 unless cur_file_num == file_list.length - 1
          current_file_name.text = "Editing: " + file_list[cur_file_num]
          current_file_long_name = long_file_list[cur_file_num]
          cur_file = File.open(current_file_long_name, mode="r+")
          file_text.text = cur_file.read
        end
      end
    end
    f
  end

  def switch_window(switch_to)
    # bug:
    # When DRYing, put switching code here
    if switch_to == "main_window"
    elsif switch_to == "editing_window"
    end
  end

  def get_file_list(long_path = false, folder_location)
    # bug:
    # For some reason @folder_location is not being sent across methods?
    # So instead have to pass in variable and set f_l to that.
    # f_l = @folder_location
    f_l = folder_location
    @file_list = Dir.entries(f_l).select { |f| File.file?(f_l + "#{f}") }
    if long_path
      @file_list.map! { |f| f = f_l + "#{f}" }
    end
    @file_list
  end
end

Shoes.app :title => "Many File Editor", :width => 700, :height => 525 do
  @many_file_editor = ManyFileEditor.new(self)
end


=begin

=end

