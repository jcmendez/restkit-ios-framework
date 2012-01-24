restkit-ios-framework
=====================

RestKit is a wonderful library.

I started this project to see if others find valuable to have a script that packages it as an iOS framework for easy
inclusion in new projects, versus the current method I've seen around that adds the whole XCode project as a sub-project

I'm currently working with the rktablecontroller branch of the RestKit library, that creates a bundle with resources for
the library.  If using the script to build a bundle for the master branch, remove the following line from the script

    cp -R "${LIBDIR}/RestKitResources.bundle" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"



