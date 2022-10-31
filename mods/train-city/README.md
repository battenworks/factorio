# train-city

My first Factorio mod. I've built out an automated train city, and I'd like to capture that concept in a mod.

Inspiration from this thread: https://forums.factorio.com/viewtopic.php?f=80&t=53473

## Known issues
- [ ] After setting an item, the train just takes off. If the cargo wagons haven't been attached, how do you track down the locomotive and fix it?
    - Add logic to prevent train from moving if it doesn't have cargo wagons?
    - Add UI element to fix it?
    - Using logic added in a patch, send them all to a depot for fixing?

### What could it do?
- [x] Train type that transports players around the city.
- [x] Train stations that are associated with items/fluids, to automatically name themselves.
- [x] Trains that are associated with items/fluids, to automatically set schedules/routes.
- [ ] Upon changing the item/fluid of a train, deliver the items/fluid the train currently has, and then go load the new items/fluid and remain on the new schedule.
- [ ] UI that allows us to see metrics/state of trains.
  - [ ] Show trending of item inventory on item cards.
  - [ ] Show trending on science packs line items. (table?)
- [x] Show science pack inventory at-a-glance
- [ ] Buttons in UI to add/remove trains from routes.
- [x] Allow an item/fluid type to be selectable while editing individual trains.
- [ ] Make trains smart enough to stop for fuel only when they need to.
  - (maybe not - having the fuel stations gives trains a place to wait, without sitting in a load station)
- [ ] Make fuel stations configurable from one place.
- [ ] Make ammo stations configurable from one place.
- [x] Enable/disable stations based on their selected item/fluid.
- [x] Make transportation-train stack size = 1.
- [ ] Change `direction` field of stations to support multiple purposes/roles:
  - [X] load
  - [X] drop
  - [ ] queue
  - [ ] warehouse
- [ ] Role switcher for player to easily choose inventory by role (terraforming, infrastructure, pods, etc.).
- [X] Add close button to the entity UIs
- [ ] Add circuit metrics to the station UIs
- [ ] Add ability to customize item name across the system. I'd like to nickname them.
    - `blue-circuit` in place of `processing-unit`, etc.
- [ ] Add domain language for `idle` trains: train whose next stop is drop/load, but `destination full`.
- [ ] Add feature to transportation-train so you can get in if you forget to before hitting "go".
- [ ] Add metric that shows how full each station is. Group stations by item and you can see if you have too few/many trains servicing the stations.
