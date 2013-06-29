
# Many File Editor

Opens a file with many near-filenames but not exactly right (for example file-name which needs to be file-name.txt), pulls out all those filenames, allows you to apply substitutions, opens those files one at a time, allows you to edit them, then saves it and goes on to the next.

## Overview

Uses the Ruby GUI toolkit Shoes.

Built for Mac OS X.

## Edge Cases

## Installing

## Installation

Go to the [Shoes website](http://shoesrb.com/downloads.html) and download Shoes.

## Usage

Open the Shoes app then open many_file_editor.rb.

Paste in the text of the near-filenames.

Add a Regex to change the near-filenames to proper filenames. Click "Apply Regex". This will show the new filenames in the edit box to the right.

Click 'Open Files'. The window will change to a big edit box with each file.

Edit the file, then click "Save" then "Next File" or "Previous File", depending on what you need.

Click "Exit" when you are done.

Main Window:

![main_window](./images/main_window.png?raw=true)

Editing Window:

![editing_window](./images/editing_window.png?raw=true)


## Examples
### Pasted in text:
pasted = <<HEREDOC
 * [[bk_BeyondQuantumTheory|Beyond Quantum Theory]]
 * [[bk_RememberWholesale|We Can Remember It For You Wholesale]]
 * [[bk_TranscentionHypothesis|Transcention Hypothesis]]
HEREDOC

### Regex Match Used:
captured = pasted.scan(/(bk_\w+)/).flatten
puts captured

### Folder with Files:
/path/file_examples/

### Desired output:
bk_BeyondQuantumTheory.markdown
bk_RememberWholesale.markdown
bk_TranscentionHypothesis.markdown



## Contributing

 - add features
