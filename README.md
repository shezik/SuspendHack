# SuspendHack
A KOReader plugin for Kindle to suspend normally without framework. (Tested on Kindle Touch)

## Usage

Place the whole "suspendhack.koplugin" folder under koreader/plugins and restart KOReader.

Then open a book. Now you should be able to put Kindle to sleep with the power button even if you launched KOReader with the "no framework" option in KUAL.

(No menu has been implemented yet.)

### Why am I not seeing the "no framework" option in KUAL?

Modify /mnt/*(us, or sd)*/extensions/koreader/menu.json to include Kindle Touch ("KindleTouch") in the support list or use the one I provided with.

## Known issues

+ ~~**Script will run but the dummy service will not be registered in File Manager,** thus you must open a book to suspend the device. *(Why??)*~~

  Magically solved for no reason.

+ Service will get terminated when Kindle goes to suspend mode.

  So I actively turn it off when going to suspend mode :)

+ You can always fall back to KPVBooklet if this doesn't work for you. *(I haven't tried that yet)*
