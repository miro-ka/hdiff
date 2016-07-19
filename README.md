# hdiff - a simple diff tool
## License ##
GNU GENERAL PUBLIC LICENSE - Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Full license](https://github.com/mkarpis/hdiff/blob/master/LICENSE)

## About ##
Hdiff is a simple diff kind tool made in Haskell. Program input are 2 files that should be compared and a list of strings (defined in config file). What program does is:
1. Take next string element from list in given config file
2. Find all occurences in file_1
3. Take entire line from file_1 where the string occured
4. Find the entire string in file_2
5. If the string does not exist in file_2 write it to output.
6. Go back to 1)

Some featues that should be mentioned:
* Program ignores position of the compared line between the files. So if compared line is on line number 10 and in the other file on line number 100, program will consider this as OK 

## Install ##
Application is packed as a Cabal package (package and build system for Haskell). So after cloning repo into your directory you can install it with:
```sh
$ cabal install
```

## Usage ##

### Input ###
```sh
$ hdiff <file_1> <file_2> <config_file> ! 
```
* **File_1, File_2**: Text files to compare
* **config_file**: File that contains list of line strings that should be looked(searched) and compared, separated by comma. List of strings must start with following line **starting_elements:**. So following would be a valid line *"starting_elements: string_1, string 1, another a bit larger string"*. Take a look at example file *hdiff.cfg_default*.

### Output ###
Writes to output missing or different lines defined in given config_file


## Bugs & Feature requests ##
Please log all bugs and feature requests to the githubs [Issues Tracker](https://github.com/mkarpis/hdiff/issues) 
