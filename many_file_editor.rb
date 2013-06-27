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
              @folder_location = ask_open_folder + "/"
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

            @para_folder_loc = para "\n", :size => 8

            # capture near_filenames with regex
            # use Ruby's substitute to change the near_filenames, perhaps?
            # apply regex to @file_list with Ruby's .scan, perhaps?
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
          end

          # example of how to use .text:
          # @folder_location = edit_line do
          #   @para.text = @folder_location.text
          # end
          # @para = para ""

          stack :width => '49%' do

            flow do
              para "\nFixed Filenames:"
              button "Paste" do
                @fixed_files_box.text = self.clipboard
              end
            end

            flow do
              button "Get File Names" do
                @names_files = { :short =>
                                 s.get_file_list(long_path = false, @folder_location),
                                 :long =>
                                 s.get_file_list(long_path = true, @folder_location) }
                @fixed_files_box.text = ""
                @names_files[:short].each { |file| @fixed_files_box.text += file + "\n" }
              end

              button "Open Files" do
                # Figure out why when the @main_window is hidden,
                # the @names_files variable becomes nil or "".
                # One way to get around this is to pass in
                # the variables to the window, but this seems hackish

                # open editing window, start with first file
                # DRY this switch_window code into a method
                if @names_files
                  @main_window.hide
                  @editing_window = s.editing_window(foobar, @names_files)
                  @editing_window.show
                end
              end
              @fixed_files_box = edit_box
            end

            button "Quit App" do
              quit
            end
          end
        end
    end
  end

  def editing_window(foobar, names_files)
    # this should work but for some reason it's not:
    # file_list = @shortnames_files

    long_file_list = names_files[:long]
    file_list = names_files[:short]
    # file_list = shortnames_files

    # perhaps in file_text start with first file in file_list
    # @file_list.each { |file| puts File.read(dirname + file) }

    f = nil
    foobar.app do
      f = flow do
        
        cur_file_num = 0
        current_file_name = para "Editing: " + file_list[cur_file_num]

        file_text = edit_box :margin => 10, :width => '98%', :height => 400 do
        end
        current_file_long_name = long_file_list[cur_file_num]
        file_text.text = File.open(current_file_long_name, mode="r+").read

        button "Quit App" do
          quit
        end
        button "Main Window" do
          @editing_window.hide()
          @main_window.show()
        end
        button "Save File" do; end
        button "Previous File" do
          cur_file_num -= 1 unless cur_file_num == 0
          current_file_name.text = "Editing: " + file_list[cur_file_num]
          current_file_long_name = long_file_list[cur_file_num]
          file_text.text = File.open(current_file_long_name, mode="r+").read
        end
        button "Next File" do
          cur_file_num += 1 unless cur_file_num == file_list.length - 1
          current_file_name.text = "Editing: " + file_list[cur_file_num]
          current_file_long_name = long_file_list[cur_file_num]
          file_text.text = File.open(current_file_long_name, mode="r+").read
        end
      end
    end
    f
  end

  def switch_window(switch_to)
    # add switching code here
    if switch_to == "main_window"
    elsif switch_to == "editing_window"
    end
  end

  def get_file_list(long_path = false, folder_location)
    # another bug:
    # Looks like @folder_location is not being sent across methods,
    # because it's always setting f_l to the path.
    # May be able to pass in folder_location variable
    # into method, then set f_l to that variable.
    # f_l = @folder_location
    f_l = folder_location
    alert f_l
    if f_l == nil
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
