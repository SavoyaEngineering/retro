import {Switch, Route} from 'react-router-dom'
import * as React from "react";
import Room from './room'
import NewRoom from './new-room'

const RoomRouter = () => (
  <main>
    <Switch>
      <Route path='/rooms/new' component={NewRoom}/>
      <Route path='/rooms/:number' component={Room}/>
    </Switch>
  </main>
);

export default RoomRouter;
