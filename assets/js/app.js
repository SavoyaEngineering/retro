import 'bootstrap';


// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import renderNewRoom from "./new-room"
import renderRooms from "./rooms"
import renderRoom from "./room"

var newRoom = document.getElementById("react-new-room");
var rooms = document.getElementById("react-rooms");
var room = document.getElementById("react-room");
if (newRoom) {
  renderNewRoom(newRoom)
}
if (rooms) {
  renderRooms(rooms)
}
if (room) {
  renderRoom(room)
}