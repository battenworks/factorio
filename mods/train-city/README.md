# train-city

My first Factorio mod. I've built out an automated train city, and I'd like to capture that concept in a mod.

Inspiration from this thread: https://forums.factorio.com/viewtopic.php?f=80&t=53473

## Known issues

### What could it do?
- [x] Train type that transports players around the city.
- [x] Train stations that are associated with items/fluids, to automatically name themselves.
- [x] Trains that are associated with items/fluids, to automatically set schedules/routes.
- [ ] Upon changing the item/fluid of a train, deliver the items/fluid the train currently has, and then go load the new items/fluid and remain on the new schedule.
- [ ] UI that allows us to see metrics/state of trains.
  - [ ] Show trending of item inventory on item cards.
- [ ] Show science pack inventory at-a-glance
- [ ] Buttons in UI to add/remove trains from routes.
- [x] Allow an item/fluid type to be selectable while editing individual trains.
- [ ] Make trains smart enough to stop for fuel only when they need to.
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
