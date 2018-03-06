import {Switch, Route} from 'react-router-dom';
import * as React from "react";
import * as ReactDOM from "react-dom";
import {BrowserRouter} from 'react-router-dom';
import Landing from "./landing";
import RoomRouter from "./room-router";
import ErrorPage from "./error-page";


const Main = () => (
  <main>
    <Switch>
      <Route exact path='/' component={Landing}/>
      <Route path='/rooms' component={RoomRouter}/>
      <Route path='/404' component={ErrorPage}/>
    </Switch>
  </main>
);

ReactDOM.render((
  <BrowserRouter>
    <Main/>
  </BrowserRouter>
), document.getElementById('main'));