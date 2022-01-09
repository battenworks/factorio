# train-city

My first Factorio mod. I've built out an automated train city, and I'd like to capture that concept in a mod.

Inspiration from this thread: https://forums.factorio.com/viewtopic.php?f=80&t=53473

## Known Issues
- Once a station has a selected item and is associated with any trains, choosing a new item for that station changes the station names in all associated trains. This behavior results in the trains staying associated with the station, but now being associated with all other stations with that newly selected item. This is probably bad.
  - Workaround: If you need to change the item associated with the station, delete the station and create a new one with the correct item selected. This will prevent the changing of the original station in trains' station lists.

What could it do?
- [x] Train type that transports players around the city.
- [x] Train stations that are associated with items, to automatically name themselves.
- [x] Trains that are associated with items, to automatically set schedules/routes.
- [ ] On a change event of item 'deliver the items you currently have, and then go load the new items and remain on the new schedule'.
- [ ] UI that allows us to see metrics/state of item trains and add/remove trains from that item route.
- [x] Allow an item type to be selectable while editing individual trains.
- [ ] Make trains smart enough to stop for fuel only when they need to.
- [ ] Make fuel stations configurable from one place.
- [ ] Make ammo stations configurable from one place.
- [ ] Role switcher for player to easily choose inventory by role (terraforming, infrastructure, pods, etc.)
- [ ] Enable/disable stations based on their selected item.
- [x] Make transportation-train stack size = 1.
