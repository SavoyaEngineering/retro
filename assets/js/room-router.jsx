import {Switch, Route} from 'react-router-dom'
import * as React from "react";
import NewRoom from './new-room'
import JoinRoom from './join-room'
import EditRoom from "./room-edit";
import Room from './room'

const RoomRouter = () => (
  <main>
    <Switch>
      <Route path='/rooms/new' component={NewRoom}/>
      <Route path='/rooms/join_room' component={JoinRoom}/>
      <Route path='/rooms/:number/edit' component={EditRoom}/>
      <Route path='/rooms/:number' component={Room}/>
    </Switch>
  </main>
);

export default RoomRouter;
