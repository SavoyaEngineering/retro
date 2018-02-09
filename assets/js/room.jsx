import * as React from "react"
import * as ReactDOM from "react-dom"
import api from './api';

class Room extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    var url = window.location.pathname;
    var id = url.substring(url.lastIndexOf('/') + 1);

    this.state = {
      happyItems: [],
      middleItems: [],
      sadItems: []
    };

    api.fetch('/api/rooms/' + id)
      .then((response) => {
        this.setState({
          happyItems: response.room.happy_items,
          middleItems: response.room.middle_items,
          sadItems: response.room.sad_items
        });
      });
  }


  render() {

    return (
      <div>
        <div className='jumbotron'>
          <h2>Retro name:</h2>
        </div>
      </div>
    )
  }
}

// <div class="jumbotron">
//   <h2><%= @room.name %></h2>
// </div>
// <div id="retro-wrapper">
//   <div class="retro-column form-group" id="happy-column">
//     <h2 class="text-center"> Happy </h2>
//     <div class="form-group">
//       <input id="happy-input" type="text" class="form-control" placeholder="New Item">
//     </div>
//     <hr>
//       <%= for item <- @happy_items do %>
//       <li class="thumbnail" id="item-<%= item.id %>"><%= item.text %></li>
//       <% end %>
//   </div>
//   <div class="retro-column" id="middle-column">
//     <h2 class="text-center"> Meh </h2>
//     <div class="form-group">
//       <input id="middle-input" type="text" class="form-control" placeholder="New Item">
//     </div>
//     <hr>
//       <%= for item <- @middle_items do %>
//       <li class="thumbnail" id="item-<%= item.id %>"><%= item.text %></li>
//       <% end %>
//   </div>
//   <div class="retro-column" id="sad-column">
//     <h2 class="text-center"> Sad </h2>
//     <div class="form-group">
//       <input id="sad-input" type="text" class="form-control" placeholder="New Item">
//     </div>
//     <hr>
//       <%= for item <- @sad_items do %>
//       <li class="thumbnail" id="item-<%= item.id %>"><%= item.text %> </li>
//       <% end %>
//   </div>
// </div>
// <div id="rooms"></div>
// <script>window.roomToken = "<%= assigns[:room_token] %>";</script>
// <script>window.roomId = "<%= @room.id %>";</script>

export default function renderRoom(node) {
  ReactDOM.render(
    (<div>
      <Room/>
    </div>),
    node
  )
}