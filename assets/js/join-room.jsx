import * as React from "react"

import api from './api';

class JoinRoom extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    let token = this.props.location.search.split("?t=")[1];
    var data: object = {temporary_token: token};
    api.post('/api/rooms/go_to_room_with_token', data)
      .then((response) => {
        localStorage.setItem("roomToken", response.room_token);
        window.location = '/rooms/' + response.room_id;
      }, (errorResponse) => {
        this.setState({errors: errorResponse.errors})
      });

  }

  render() {
    return (
      <div className='jumbotron'>
        <h2>Joining Retro</h2>
        <p>Please wait.</p>
      </div>
    )
  }
}

export default JoinRoom;
