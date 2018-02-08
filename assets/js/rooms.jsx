import * as React from "react"
import * as ReactDOM from "react-dom"
import api from './api';

class Rooms extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.state = {
      rooms: []
    };
    this.enterPassword = this.enterPassword.bind(this);
    this.goToRoom = this.goToRoom.bind(this);

    api.fetch('/api/rooms')
      .then((response) => {
        this.setState({rooms: response.rooms});
      });
  }

  enterPassword(changingRoom, event) {
    this.state.rooms.map(function (room) {
      if (changingRoom.id === room.id) {
        room.password = event.target.value;
      }
      return room;
    });
  }

  goToRoom(room, event) {
    event.preventDefault();
    var data:object = {id: room.id, password: room.password};
    api.post('/api/rooms/go_to_room', data)
      .then((response) => {
        localStorage.setItem("roomToken", response.room_token);
        window.location = '/rooms/' + room.id;
      }, (errorResponse) => {
        console.log("error");
    });
  }

  render() {
    const rooms = this.state.rooms.map((room: object) =>
      <tr key={room.id}>
        <th>{room.name}</th>
        <th>
          <input type="text" name="room-password" className="form-control" placeholder="Password" id="room-{room.id}-password"
                 value={room.password} onChange={this.enterPassword.bind(this, room)}/>
        </th>
        <th>
          <input type="button" value="Go to Retro" className="btn btn-primary" onClick={this.goToRoom.bind(this, room)}/>
        </th>
      </tr>
    );
    
    return (
      <div>
        <div className='jumbotron'>
          <h2>Select a retro room</h2>
        </div>
        <table className="table">
          <thead>
            <tr><th>Retro</th><th>Password</th><th></th></tr>
          </thead>
          <tbody>
            {rooms}
          </tbody>
        </table>

      </div>
    )
  }
}

export default function renderRooms(node) {
  ReactDOM.render(
    (<div>
      <Rooms/>
    </div>),
    node
  )
}