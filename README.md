Pascal Draw
==========

![A Picture Drawn in PascalDraw](http://i.imgur.com/N96DLxG.png)

ASCII drawing canvas written in Pascal.

##Usage

### Basics
Moving your `#` cursor around using the arrow keys.
There are 15 colors, and each one comes with four shades.

To draw, use the keys `Z`,`X`,`C`,`V`; where `Z` is the lighest shade of the currently chosen color and `V` is the darkest shade.
You can switch colors by pressing the key displayed next to.

### Erasing
Erase the current pixel by pressing `D`.
Erase the whole canvas by pressing `Shift + D`.

### Opening / Saving
Open a project file using `Shift + I` (Input).
Saving the current project using `Shift + O` (Output).

### Exporting
Pascal Draw supports HTML exporting. Why? Because I can't really figure out how to encode properly in TXT files.
To export, use `Shift + E` (Export). Please be reminded that exporting does NOT mean saving the project.

## Storage
### PascalDraw File(.pdr)
***PascalDraw File*** saves PascalDraw project. It's pretty much like HTML Export but you can edit it and save it again.

Data is separated by spaces and new-line-characters. The first chunk is the number of pixels in the project, followed by a new line `\n`.
Each 4 chunks (separated by space-character) of the following data defines a pixel in the project file.

It is structured like so:
```
[numbers of pixels]
[x] [y] [shade] [color] [x] [y] [shade] [color] [x] [y] [shade] [color] ...
```

<u>Notes: </u>
* The file must **not** end with a space character. Though this haven't been tested whether it would cause a bug or not, it shouldn't be like that.
* The most top-left pixel has the coordinate (0;0)

### Config file (config)
Saves configurations about PascalDraw. Currently, it supports saving the Current Working Directory (CWD). 


It is structured like so:
```
CWD=C:\path\to\working\directory\
```

## Coverage

Since the support of `config` file, PascalDraw is expected to only support DOS or Windows. Pascal, of course, does support file handling for *nix systems but I don't bother writing chunks of code that is written exactly the same but with extra characters.