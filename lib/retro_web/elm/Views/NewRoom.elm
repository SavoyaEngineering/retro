module Views.NewRoom exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href)


type Msg
    = NewRoomMsg


view : Html Msg
view =
    div [class "jumbotron"]
        [ h2 []
            [ text "Create a retro for you and your friends"]
        ]


--<div class="jumbotron">
--  <h2>Create a retro for you and your friends</h2>
--</div>
--
--<%= form_for @changeset, room_path(@conn, :create), fn f -> %>
--  <%= if @errors do %>
--    <%= for error <- @changeset.errors do %>
--      <div class="text-danger"><%= readable_error(error) %></div>
--    <% end %>
--  <% end %>
--  <form>
--    <div class="form-group">
--      <label for="roomName">Name</label>
--      <%= text_input f, :name, class: "form-control", id: "roomName", placeholder: "Retro Name"%>
--    </div>
--    <div class="form-group">
--      <label for="roomPassword">Password</label>
--      <%= text_input f, :password, class: "form-control", id: "roomPassword", type: "passwword", placeholder: "password"%>
--    </div>
--    <button type="submit" class="btn btn-primary">Create</button>
--  </form>
--<% end %>