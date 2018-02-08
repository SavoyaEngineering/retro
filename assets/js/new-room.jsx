import * as React from "react"
import * as ReactDOM from "react-dom"

class NewRoom extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.state = {
      roomName: '',
      roomPassword: ''
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  handleSubmit(event) {
    event.preventDefault();
    console.log('name was ' + this.state.roomName + ' and password was ' + this.state.roomPassword);
    event.preventDefault();
  }

  render() {
    return (
      <div>
        <div className='jumbotron'>
          <h2>Create a retro for you and your friends</h2>
        </div>
        <form onSubmit={this.handleSubmit}>
          <div className="form-group">
            <label htmlFor="room-name">
              Name:
            </label>
            <input type="text" name="room-name" className="form-control" placeholder="Retro Name"
                   value={this.state.roomName} onChange={this.handleChange.bind(this, 'roomName')}/>
          </div>
          <div className="form-group">
            <label htmlFor="room-password">
              Password:
            </label>
            <input type="text" name="room-password" className="form-control" placeholder="Password"
                   value={this.state.roomPassword} onChange={this.handleChange.bind(this, 'roomPassword')}/>
          </div>
          <input type="submit" value="Submit" className="btn btn-primary"/>
        </form>
      </div>
    )
  }
}

export default function render(node) {
  ReactDOM.render(
    (<div>
      <NewRoom/>
    </div>),
    node
  )
}