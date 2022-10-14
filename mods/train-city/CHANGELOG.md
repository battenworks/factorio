# 0.3.0

## Planned
Add some inventory data to the ammo and fuel tabs of the dashboard.

Change domain language to:
- replace `gui` with `view`
- replace `card` with `view_model`, or `vm`
- replace `behavior` with `?`?

# 0.2.1

## Bug Fix
After the 0.2.0 refactor, the GUI element naming was incorrect.
The base GUI names were being used, instead of the more specific GUI names.
This made the GUIs default to `fluid` type behavior, even when the GUI was for the `item` type.
Item GUI elements now declare their element names and pass those to the base GUI, so item types are processed correctly.
