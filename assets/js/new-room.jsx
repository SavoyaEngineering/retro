import * as React from "react"

import api from './api';

class NewRoom extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.state = {
      name: "",
      password: "",
      errors: []
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  handleSubmit(event) {
    event.preventDefault();
    var data: object = {name: this.state.name, password: this.state.password};
    api.post('/api/rooms', data)
      .then((response) => {
        localStorage.setItem("roomToken", response.room_token);
        localStorage.setItem("roomId", response.room_id);
        window.location = '/rooms/' + response.room_id;
      }, (errorResponse) => {
        this.setState({errors: errorResponse.errors})
      });
  }

  render() {
    const errors = this.state.errors.map((error: string) => <div className="text-danger" key={error}>{error}</div>);
    return (
      <div>
        <div className="jumbotron row">
          <div className="col-md-2">
            <img className="logo-landing" alt="Retro" src="../images/retro.svg"/>
          </div>
          <div className="col-md-10">
            <h2>Create a Retro for you and your friends.</h2>
            <p>A Retro is a room for collaborative meetings. Choose a name and password to get started.</p>
          </div>
        </div>
        <form onSubmit={this.handleSubmit} className="col-md-4 col-md-offset-4">
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
          <input type="submit" value="Create Retro" className="btn btn-primary"/>
        </form>
      </div>
    )
  }
}

export default NewRoom;
