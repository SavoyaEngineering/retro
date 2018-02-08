import * as React from "react"
import * as ReactDOM from "react-dom"

class NewRoom extends React.Component<any, any> {
    render() {
        var type: string = "TSX";
        return (
            <div>
                <div className='jumbotron'>
                    <h2>Create a retro for you and your friends</h2>
                </div>
                <form>
                    <div className="form-group">
                        <label for="room-name">
                            Name:
                        </label>
                        <input type="text" name="room-name" className="form-control" placeholder="Retro Name"/>
                    </div>
                    <div className="form-group">
                        <label for="room-password">
                            Password:
                        </label>
                        <input type="text" name="room-password" className="form-control" placeholder="Password"/>
                    </div>
                    <input type="submit" value="Submit" className="btn btn-primary"/>
                </form>
            </div>
        )
    }
}


// <div class="jumbotron">
//     <h2>Create a retro for you and your friends</h2>
//     <div id="react-new-room"></div>
// </div>
//
// <%= form_for @changeset, room_path(@conn, :create), fn f -> %>
// <%= if @errors do %>
// <%= for error <- @changeset.errors do %>
// <div class="text-danger"><%= readable_error(error) %></div>
//     <% end %>
//     <% end %>
//     <form>
//     <div class="form-group">
//     <label for="roomName">Name</label>
// <%= text_input f, :name, class: "form-control", id: "roomName", placeholder: "Retro Name"%>
// </div>
// <div class="form-group">
//     <label for="roomPassword">Password</label>
// <%= text_input f, :password, class: "form-control", id: "roomPassword", type: "passwword", placeholder: "password"%>
// </div>
// <button type="submit" class="btn btn-primary">Create</button>
//     </form>
//     <% end %>


export default function render(node) {
    ReactDOM.render(
        (<div>
            <NewRoom/>
        </div>),
        node
    )
}