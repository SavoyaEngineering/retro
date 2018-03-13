import {Switch, Route} from 'react-router-dom';
import * as React from "react";
import * as ReactDOM from "react-dom";
import {BrowserRouter} from 'react-router-dom';
import Landing from "./landing";
import RoomRouter from "./room-router";
import ErrorPage from "./error-page";

class NavBar extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.roomId = localStorage.getItem("roomId");
    this.roomLink = "/rooms/" + this.roomId;
  }

  render() {
    return (
      <nav className="navbar navbar-default">
        <div className="container">
          <div className="container-fluid">
            <div className="navbar-header">
              <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span className="sr-only">Toggle navigation</span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
              </button>
              <a className="navbar-brand" href="/">
                <img className="logo" alt="Retro" src="../images/retro.svg"/>
              </a>
            </div>
            <div className="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
              <ul className="nav navbar-nav">
                <li><a href="/rooms/new">Create A Retro</a></li>
              </ul>
              {this.roomId &&
              <ul className="nav navbar-nav navbar-right">
                <li><a href={this.roomLink}>My Retro</a></li>
              </ul>
              }
            </div>
          </div>
        </div>
      </nav>
    )
  }
};


const Main = () => (
  <div className="container main">
    <Switch>
      <Route exact path='/' component={Landing}/>
      <Route path='/rooms' component={RoomRouter}/>
      <Route path='/404' component={ErrorPage}/>
    </Switch>
  </div>
);

ReactDOM.render((
  <BrowserRouter>
    <div>
      <NavBar/>
      <Main/>
    </div>
  </BrowserRouter>
), document.getElementById('main'));