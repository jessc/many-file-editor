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

            para "Near-Filenames:"
            # for some reason when you increase the :height it
            # throws off the Quit App button at the bottom of the rightside?
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

            # capture near_filenames with regex
            # use Ruby's substitute to change the near_filenames, perhaps?
            # apply regex to @file_list with Ruby's .scan, perhaps?
            para "Regex:"
            @regex = edit_line
            @regex.text = "/put_regex_here/"
            flow do
              button "Copy" do
                self.clipboard = @regex.text
              end
              button "Paste" do
                @regex.text = self.clipboard
              end
              button "Apply" do
                # placeholder code
                @near_filenames = <<HEREDOC
 * [[bk_BeyondQuantumTheory|Beyond Quantum Theory]]
 * [[bk_RememberWholesale|We Can Remember It For You Wholesale]]
 * [[bk_TranscentionHypothesis|Transcention Hypothesis]]
HEREDOC

                if @near_filenames
                  applied_regex = @near_filenames.scan(/(bk_\w+)/).flatten
                  caught_filenames = ""
                  applied_regex.each { |file| caught_filenames += file + "\n" }
                  @fixed_files_box.text = caught_filenames
                end
              end
            end

            para "Add File Extension:"
            @file_extension = edit_line
            button "Apply" do
              if @fixed_files_box.text != ""
                # placeholder code
                alert "worked"
              end
            end
          end
          
          stack :width => '49%' do

            button "Location of Files" do
              @folder_location = ask_open_folder + "/"
              @para_folder_loc.text = @folder_location
            end
            @para_folder_loc = para "No folder chosen yet.\n", :size => 8

            stack do
              para "Fixed Names:"
              @fixed_files_box = edit_box :width => '90%', :height => 275
            end

            # Eventually this button will be deleted,
            # because the user flow will be
            # input near-filenames and folder location
            # apply Ruby substitution, put that in fixed_files_box
            # Open Files button to open each file
            flow do
              button "Get Names" do
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
              button "Paste" do
                @fixed_files_box.text = self.clipboard
              end
            end
            button "Quit App", {:right => 0, :bottom => 0} do
              quit
            end
          end
        end
    end
  end

  def editing_window(foobar, names_files)
    # this should work but for some reason it's not:
    # file_list = @names_files

    long_file_list = names_files[:long]
    file_list = names_files[:short]

    # perhaps in file_text start with first file in file_list
    # @file_list.each { |file| puts File.read(dirname + file) }

    f = nil
    foobar.app do
      f = flow do
        
        cur_file_num = 0
        current_file_name = para "Editing: " + file_list[cur_file_num]
        file_saved = para "", :size => 8

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

Shoes.app :title => "Many File Editor", :width => 700, :height => 525 do
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
