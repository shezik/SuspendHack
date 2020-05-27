# SuspendHack
A KOReader plugin for Kindle to suspend normally without framework.

## Usage

Put the whole "suspendhack.koplugin" folder under koreader/plugins and restart KOReader.

Then open a book. Now you should be able to put Kindle to sleep with a press of the power button even if you launched KOReader with the "no framework" option in KUAL.

(No menu is implemented yet.)

## Known issues

+ **Script will run but the dummy service will not be registered in File Manager,** thus you must open a book to suspend the device. *(Why??)*

+ Service will get terminated when Kindle goes to suspend mode.

  This problem can be bypassed by using an individual process to handle the service.

+ You can always fall back to KPVBooklet if this doesn't work for you. *(I haven't tried that yet)*