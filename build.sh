#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_KMSDRM_OPTION='disable'
SHED_PKG_LOCAL_WAYLAND_OPTION='disable'
SHED_PKG_LOCAL_GLES_OPTION='disable'
SHED_PKG_LOCAL_GL_OPTION='disable'
SHED_PKG_LOCAL_DUMMY_VIDEO_OPTION='enable'
for SHED_PKG_LOCAL_OPTION in "${!SHED_PKG_LOCAL_OPTIONS[@]}"; do
    case "$SHED_PKG_LOCAL_OPTION" in
        kmsdrm)
            SHED_PKG_LOCAL_KMSDRM_OPTION='enable'
            SHED_PKG_LOCAL_DUMMY_VIDEO_OPTION='disable'
            ;;
        wayland)
            SHED_PKG_LOCAL_WAYLAND_OPTION='enable'
            SHED_PKG_LOCAL_DUMMY_VIDEO_OPTION='disable'
            ;;
        gles)
            SHED_PKG_LOCAL_GLES_OPTION='enable'
            SHED_PKG_LOCAL_DUMMY_VIDEO_OPTION='disable'
            ;;
    esac
done
./configure --prefix=/usr \
            --enable-alsa \
	    --disable-pulseaudio \
	    --disable-video-mir \
	    --disable-video-x11 \
	    --disable-video-rpi \
	    --${SHED_PKG_LOCAL_KMSDRM_OPTION}-video-kmsdrm \
	    --${SHED_PKG_LOCAL_WAYLAND_OPTION}-video-wayland \
	    --${SHED_PKG_LOCAL_GLES_OPTION}-video-opengles \
      --disable-video-opengl \
	    --disable-video-vulkan &&
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
# Remove static libraries
rm -v "${SHED_FAKE_ROOT}"/usr/lib/libSDL2*.a
