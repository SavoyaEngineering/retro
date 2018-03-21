import * as React from "react"
import api from './api';
import LogoImg from "../static/images/retro.svg";

class EditRoom extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    const id = localStorage.getItem("roomId");

    this.state = {
      room: {
        id: null,
        retro_day: "",
        retro_time: ""
      },
      members: []
    };

    this.getMembers = function () {
      api.fetch('/api/rooms/' + id + '/members').then((response) => {
        this.setState({members: response.members});
      });
    };

    api.fetch('/api/rooms/' + id).then((response) => {
      let room = response.room;
      this.setState({
        room: room
      });
    }, () => {
      window.location = "/404";
    });

    this.getMembers();
  }

  changeRetroTime(event) {
    let room = this.state.room;
    room.retro_time = event.target.value;
    this.setState({room: room});
  }

  selectRetroDay(day) {
    let room = this.state.room;
    room.retro_day = day;
    this.setState({room: room});
  }

  updateRoom(event) {
    event.preventDefault();
    api.put("/api/rooms/" + this.state.room.id, this.state.room).then((response) => {
      this.setState({room: response.room})
    });
  }

  deleteMember(member) {
    api.destroy("/api/rooms/" + this.state.room.id + "/members/" + member.id).then(() => {
      this.getMembers()
    });
  }

  render() {
    this.members = function () {
      return this.state.members.map((member: object) =>
        <div className="thumbnail col-md-4 col-md-offset-4" key={member.id}>
          {member.email}
          <span className="pull-right">
            <a onClick={this.deleteMember.bind(this, member)} href="#">
              Delete
            </a>
          </span>
        </div>
      )
    };

    return (
      <div>
        <div className="jumbotron row">
          <div className="col-md-2">
            <img className="logo-landing" alt="Retro" src={LogoImg}/>
          </div>
          <div className="col-md-10">
            <h2>{this.state.room.name}</h2>
            <p>Customize your Retro below.</p>
          </div>
        </div>

        <h4 className="col-md-8 col-md-offset-2">
          You can set up a time to send out an email reminder to those listed below for future meetings.
          Choose a day and enter a military time (ex. 1620) that email reminders should be send out (America/Chicago).
        </h4>
        <div className="form-group col-md-1 col-md-offset-4">
          <div className="btn-group">
            <button type="button" className="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              {this.state.room.retro_day} <span className="caret"></span>
            </button>
            <ul className="dropdown-menu">
              <li onClick={this.selectRetroDay.bind(this, "Monday")}><a href="#">Monday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Tuesday")}><a href="#">Tuesday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Wednesday")}><a href="#">Wednesday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Thursday")}><a href="#">Thursday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Friday")}><a href="#">Friday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Saturday")}><a href="#">Saturday</a></li>
              <li onClick={this.selectRetroDay.bind(this, "Sunday")}><a href="#">Sunday</a></li>
            </ul>
          </div>
        </div>
        <div className="form-group col-md-2">
          <input type="text" className="form-control" placeholder="1620"
                 value={this.state.room.retro_time} onChange={this.changeRetroTime.bind(this)}/>
        </div>
        <div className="form-group col-md-5">
          <button className="btn btn-primary"
                  onClick={this.updateRoom.bind(this)}>Update</button>
        </div>

        <h4 className="col-md-8 col-md-offset-2">
          Below are the members of this Retro. They will receive an email at Retro time.
        </h4>
        {this.members()}
      </div>
    )
  }
}

export default EditRoom;
