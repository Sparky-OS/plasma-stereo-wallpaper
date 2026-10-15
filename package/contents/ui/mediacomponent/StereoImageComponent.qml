/*
    SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2014 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2014 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2026 Daniel Ramos <Capitain_Jack@yahoo.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
pragma ComponentBehavior: Bound

import QtQuick
import org.kde.plasma.wallpapers.image as Wallpaper
import org.sparky.stereo as Stereo

/**
 * A still picture that may be a stereo pair.
 *
 * The shared policy (org.sparky.stereo, libstereo-layer) decides whether the file is a pair:
 * its mark (MPO, JPS, PNG sTER, a marked JPEG), its format, and for an unmarked picture its content.
 * A pair gets its own surface below the desktop, declared full side by side, on a screen that shows two eyes;
 * on a 2D screen it draws its left view and declares nothing. Icons and widgets stay on the desktop's surface.
 * An ordinary picture is drawn by the same image item as the Image wallpaper, so nothing changes for it.
 */
BaseMediaComponent {
    id: stereoImageComponent

    readonly property int status: stereoPicture.stereo ? Image.Ready : mainImage.status

    blurSource: blurLoader.item

    /**
     * A wallpaper package ships its stereo pair beside the flat picture: contents/stereo/<2w>x<h>.pns
     * for contents/images/<w>x<h>.<ext>. A plain file is its own source.
     */
    function stereoSource(source: url): url {
        const match = /^(.*)\/contents\/images\/(\d+)x(\d+)\.[^./]+$/.exec(source.toString());
        if (match) {
            return match[1] + "/contents/stereo/" + (2 * Number(match[2])) + "x" + match[3] + ".pns";
        }
        return source;
    }

    Wallpaper.TransientImage {
        id: mainImage
        anchors.fill: parent
        visible: !stereoPicture.stereo

        fillMode: stereoImageComponent.fillMode
        source: stereoImageComponent.source
    }

    Stereo.StereoPicture {
        id: stereoPicture
        anchors.fill: parent
        visible: stereo

        source: stereoImageComponent.stereoSource(stereoImageComponent.source)
        // The library fits one view inside the item; "Scaled and cropped" asks for the zoom that fills it.
        zoom: {
            if (!stereo || stereoImageComponent.fillMode !== Image.PreserveAspectCrop
                || pictureSize.width < 1 || pictureSize.height < 1 || width < 1 || height < 1) {
                return 1;
            }
            const fit = Math.min(width / pictureSize.width, height / pictureSize.height);
            return Math.max(width / (pictureSize.width * fit), height / (pictureSize.height * fit));
        }
    }

    Loader {
        id: blurLoader
        anchors.fill: parent
        z: 0
        active: stereoImageComponent.blurEnabled
        sourceComponent: Image {
            asynchronous: true
            cache: false
            autoTransform: true
            fillMode: Image.PreserveAspectCrop
            source: mainImage.source
            sourceSize: mainImage.sourceSize
            visible: false // will be rendered by the blur
        }
    }
}
