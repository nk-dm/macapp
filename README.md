# macapp
A simple script to create macOS App-Bundles(.app) out of "Unix Executables"(binary files)
# usage:
## `-bin ...` (mandatory)
The user specify the binary file that has to be "converted" into a .app-file.
The example
```
./macapp.sh -bin MyBinary
```
will create the App-Bundle `MyBinary.app` with the binary `MyBinary`.

## `-name ...` (optional)
The name of the application. Defaults to the binary's name.

## `-out ...` (optional)
The name of the App-Bundle(.app-file). Defaults the the binary's name + `.app`.

## `-ico ...` (optional)
The icon of the application. Must be a `.icns` file. If not specified, the default macOS App-Icon is shown.

## `-inf ...` (optional)
Allows you to use a predefined `Info.plist`. If not set, one will automatically be generated.

## `-ver ...` (optional)
(If `-inf` is not set)
The application's version. Must satisfy the [following criteria](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102364):
   * The first number represents the most recent major release and is limited to a maximum length of four digits.
   * The second number represents the most recent significant revision and is limited to a maximum length of two digits.
   * The third number represents the most recent minor bug fix and is limited to a maximum length of two digits.
   If the value of the third number is 0, you can omit it and the second period.

## `-appid ...` (optional but recommended)
(If `-inf` is not set)
The application's [Identifier](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070).
Must be in reverse-DNS format(i.e. com.nk-dm.macapp).

## `-res ...` (optional)
Allows you to choose to copy a resource folder(`.icns`-file not included). This is where most of/all your resources should go.
If the path is relative to the binary(which it should be), then this folder's path will be `../Resources`.

## `--override` (optional)
This will override the App-Bundle(`.app`-file, see `-out`) in case it alredy exsists.

## `--edit-info`
This will open the `Info.plist` with the default application at the end of the script.
That allows you to edit far more of [the application's attributes](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009248-SW1).

## `--help`
Prints the following line of text:
```
usage: macapp -bin binary [-out Out.app] [-ico ico.icns] [-inf info.plist] [-res resource folder] [-name Myapp] [-appid com.eg.Myapp] [-ver 1.2.3a4] [--edit-info] [--override]
```
