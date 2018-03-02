import * as React from "react"
import api from "./api";

class Landing extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.state = {
      name: "",
      password: "",
      errors: []
    };
    this.handleChange = this.handleChange.bind(this);
    this.goToRoom = this.goToRoom.bind(this);
  }

  handleChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  goToRoom(event) {
    event.preventDefault();
    var data:object = {name: this.state.name, password: this.state.password};
    api.post('/api/rooms/go_to_room', data)
      .then((response) => {
        localStorage.setItem("roomToken", response.room_token);
        window.location = '/rooms/' + response.room_id;
      }, (errorResponse) => {
        this.setState({errors: errorResponse.errors})
      });
  }


  render() {
    const errors = this.state.errors.map((error: string) => <div className="text-danger" key={error}>{error}</div>);
    return (
      <div>
        <div className="jumbotron">
          <h2>Retro provides a space for retroactive meetings.</h2>
          <p>Login to your Retro.</p>
        </div>

        <form onSubmit={this.goToRoom} className="col-md-4 col-md-offset-4">
          <div>
            {errors}
          </div>
          <div className="form-group">
            <label htmlFor="room-name">
              Name:
            </label>
            <input type="text" name="room-name" className="form-control" placeholder="Retro Name"
                   value={this.state.name} onChange={this.handleChange.bind(this, "name")}/>
          </div>
          <div className="form-group">
            <label htmlFor="room-password">
              Password:
            </label>
            <input type="password" name="room-password" className="form-control" placeholder="Password"
                   value={this.state.password} onChange={this.handleChange.bind(this, "password")}/>
          </div>
          <input type="submit" value="Join Retro" className="btn btn-primary"/>
        </form>

        <div className="col-md-4 col-md-offset-4">
          <hr/>
          <span className="">Don't have a Retro yet?</span>
          <span>
            <a href="/rooms/new"> Create a Retro </a>
          </span>
        </div>
      </div>
    )
  }
}

export default Landing;
