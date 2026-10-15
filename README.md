# plasma-stereo-wallpaper

The Stereo Image wallpaper for KDE Plasma: a stereo picture as the desktop's background, both views in 3D on a screen in a 3D mode, the left view on a 2D screen.

It is Plasma's Image wallpaper (`org.kde.image`, plasma-workspace `wallpapers/image`) with one component added.
Where the Image wallpaper draws a still picture, `StereoImageComponent.qml` asks the shared stereo policy of [stereo-layer](https://github.com/Sparky-OS/stereo-layer) (`org.sparky.stereo`, the `StereoPicture` item) whether the file is a pair: its mark (MPO per CIPA DC-007, JPS, the PNG `sTER` chunk, a marked JPEG), its format, and for an unmarked picture its content.
A pair gets its own surface below the desktop's, declared full side by side, left eye first, only on a screen that shows two eyes; the desktop's own surface keeps a hole over it, so icons, widgets and panels stay on the flat layer and are identical in both eyes.
On a 2D screen the pair's left view is drawn and nothing is declared.
An ordinary picture is drawn by the same image item as the Image wallpaper, so for it nothing changes.

The picture of a wallpaper package comes from `contents/images/<w>x<h>.<ext>` as in every Plasma wallpaper; its stereo pair, when the package has one, sits beside it as `contents/stereo/<2w>x<h>.pns` (the shape of the edition's own stereo wallpapers).
Pictures chosen as files (`.mpo`, `.jps`, `.pns`, a marked `.jpg` or `.png`) are their own source.
The configuration page, the slideshow folders, the fill modes and the colour are the Image wallpaper's; "Scaled and cropped" fills the area with each view, the other modes fit each view inside it.

Wallpaper changers set it as they set the Image wallpaper: the plugin is `org.sparky.stereoimage`, its configuration group `Wallpaper/org.sparky.stereoimage/General`, the picture in `Image`.

## Building

```
cmake -B build -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
cmake --install build
```

Needs extra-cmake-modules and libplasma's CMake macros to build; at run time plasma-workspace (the `org.kde.plasma.wallpapers.image` module), libstereo-layer 1.4.2 or later (the `stereo` and `pictureSize` properties of `StereoPicture`), and the edition's KImageFormats for MPO, JPS and PNS.

## Where this comes from

The QML under `package/contents/ui` is plasma-workspace 6.7.4's `wallpapers/image/imagepackage`, by Marco Martin, Sebastian Kügler, Kai Uwe Broulik, David Redondo, Fushan Wen and Vlad Zahorodnii, GPL-2.0-or-later, with `ImageStackView.qml` pointed at the stereo component and the plugin id checks renamed.
The same change applied inside `org.kde.image` is the shape of an offer to plasma-workspace, after the shared policy library is available to it.

Sparky Stereo OS, Daniel Ramos's edition of SparkyLinux (by Paweł "pavroo" Pijanowski).
