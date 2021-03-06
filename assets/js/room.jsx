import * as React from "react"
import api from './api';
import {Socket} from "phoenix"
import Jumbotron from "./jumbtron";

class Room extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    const url = window.location.pathname;
    const id = url.substring(url.lastIndexOf('/') + 1);

    this.state = {
      room: {
        id: null,
        items: [],
        retro_day: null,
        retro_time: null
      },
      emails: "",
      happyItems: [],
      middleItems: [],
      sadItems: [],
      actionItems: [],
      happy_msg: "",
      middle_msg: "",
      sad_msg: "",
      action_msg: "",
      showInvite: false,
      members: [],
    };

    this.itemsForColumn = function (type: string) {
      return this.state.room.items.filter(item => {
        return item.type === type && !item.archived;
      });
    };

    this.setupColumnItems = function () {
      this.setState({
        happyItems: this.itemsForColumn("happy_msg"),
        middleItems: this.itemsForColumn("middle_msg"),
        sadItems: this.itemsForColumn("sad_msg"),
        actionItems: this.itemsForColumn("action_msg"),
      })
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

      this.setupColumnItems(this);

      //setup socket connection
      let socket = new Socket("/socket", {params: {token: this.state.room.socket_token}});
      socket.connect();
      this.channel = socket.channel("room:" + response.id, {});

      //setup listener for when a retro item is selected
      this.channel.on("select_item", payload => {
        this.state.room.items.map(item => {
          item.selected = payload.item_id === item.id;
        });

        this.setupColumnItems(this);
      });

      //setup listener for when an item is updated
      this.channel.on("update_item", updatedItem => {
        const room = this.state.room;
        room.items = this.state.room.items.map(item => {
          if (item.id !== updatedItem.id) {
            return item;
          } else {
            return updatedItem
          }
        });
        this.setState({
          room: room
        });
        this.setupColumnItems();
      });

      //setup thumbs up listener
      this.channel.on("thumbs_up", payload => {
        const room = this.state.room;
        room.items = this.state.room.items.map(item => {
          if (item.id === payload.item_id) {
            item.thumbs_up_count += 1;
          }
          return item
        });
        this.setState({
          room: room
        });
      });

      //setup new msg listener
      this.channel.on("new_msg", payload => {
        this.state.room.items.push(payload);
        this.setupColumnItems();
      });

      //join the channel
      this.channel.join()
        .receive("ok", resp => {
          console.log("Joined successfully", resp)
        })
        .receive("error", resp => {
          console.log("Unable to join", resp)
        });
    }, () => {
      window.location = "/404";
    });

    this.getMembers();
  }

  handleInputChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  handleTextChange(item, event) {
    this.state.room.items.map(listItem => {
      if(item.id === listItem.id) {
        return listItem.text = event.target.value;
      }
    });

    this.setupColumnItems(this);
  }

  addItem(type: string) {
    this.channel.push(type, {body: this.state[type], room_id: this.state.room.id});
    this.setState({[type]: ""})
  }

  focusItem(item, event) {
    event.preventDefault();
    this.channel.push("select_item", {item_id: item.id});
  };

  archiveItem(item) {
    item.archived = true;
    this.channel.push("update_item", item);
  };

  thumbsUp(item, event) {
    event.preventDefault();
    this.channel.push("thumbs_up", {item_id: item.id})
  }

  editing(item, editable, event) {
    if(event) {
      event.preventDefault();
    }
    this.state.room.items.map(listItem => {
      if(item.id === listItem.id) {
        listItem.editable = editable;
      }
    });

    this.setupColumnItems(this);
  }

  saveEdit(item, event) {
    event.preventDefault();
    this.channel.push("update_item", item);
    this.editing(item, false)
  }

  showInvite(event) {
    event.preventDefault();
    this.setState({showInvite: !this.state.showInvite})
  }

  invite(event) {
    event.preventDefault();
    api.post("/api/rooms/" + this.state.room.id + "/members/invite", {emails: this.state.emails}).then(() => {
      this.setState({emails: "", showInvite: false});
      this.getMembers();
    });
  }

  editRoom(event) {
    event.preventDefault();
    this.props.history.push("/rooms/" + this.state.room.id + "/edit");
  }

  render() {
    this.renderItems = function (items, skipThumbsUp) {
      return items.map((item: object) =>
        <div className="thumbnail" key={item.id}>
          {item.editable ? (
            <div>
              <textarea className="form-control" placeholder="New text"
                     value={item.text} onChange={this.handleTextChange.bind(this, item)}/>
              <button className="btn-sm btn-secondary"
                      onClick={this.saveEdit.bind(this, item)}>Save</button>
            </div>
          ) :
          (<div className={item.selected ? "caption selected-item" : "caption"} id={item.id}>
            <a onClick={this.focusItem.bind(this, item)} className="center-block" href="#">
              {item.text}
            </a>
            {(!item.selected && !skipThumbsUp) &&
              <div>
                <button className="btn-sm btn-secondary"
                        onClick={this.thumbsUp.bind(this, item)}>+{item.thumbs_up_count}</button>
                <button className="btn-sm btn-secondary"
                        onClick={this.editing.bind(this, item, true)}>Edit</button>
              </div>
            }
            {item.selected &&
            <button className="btn btn-primary"
                    onClick={this.archiveItem.bind(this, item)}>Archive</button>
            }
          </div>)}
        </div>
      )
    };

    this.memberEmails = function () {
      if (this.state.members !== []) {
        return this.state.members.map(member => member.email).join(", ")
      } else {
        return "No members yet";
      }
    };

    const happyItems = this.renderItems(this.state.happyItems);
    const middleItems = this.renderItems(this.state.middleItems);
    const sadItems = this.renderItems(this.state.sadItems);
    const actionItems = this.renderItems(this.state.actionItems, true);
    return (
      <div>
        {Jumbotron({
          header: this.state.room.name,
          message: <a onClick={this.showInvite.bind(this)} className="clickable">Invite others to this Retro</a>
        })}
        {this.state.showInvite &&
        <div className="jumbotron">
          <p>Invitations have been sent to: {this.memberEmails()}</p>
          <div className="form-group">
            <input type="text" className="form-control" placeholder="first@example.com, second@example.com"
                   value={this.state.emails} onChange={this.handleInputChange.bind(this, "emails")}/>
          </div>
          <div className="form-group">
            <button className="btn btn-primary"
                    onClick={this.invite.bind(this)}>Send Invite Email
            </button>
          </div>
          <div className="form-group">
            <button className="btn btn-primary"
                    onClick={this.editRoom.bind(this)}>Retro Options
            </button>
          </div>
        </div>
        }
        <div className="row">
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something happy"
                value={this.state.happy_msg} onChange={this.handleInputChange.bind(this, "happy_msg")}/>
            </div>
            <button className="btn btn-primary"
                    onClick={this.addItem.bind(this, "happy_msg")}>Add Item</button>
            <hr/>
            {happyItems}
          </div>
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something meh"
                     value={this.state.middle_msg} onChange={this.handleInputChange.bind(this, "middle_msg")}/>
            </div>
            <button className="btn btn-primary"
                    onClick={this.addItem.bind(this, "middle_msg")}>Add Item</button>
            <hr/>
            {middleItems}
          </div>
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something sad"
                     value={this.state.sad_msg} onChange={this.handleInputChange.bind(this, "sad_msg")}/>
            </div>
            <button className="btn btn-primary"
                    onClick={this.addItem.bind(this, "sad_msg")}>Add Item</button>
            <hr/>
            {sadItems}
          </div>
        </div>
        <hr className="seperator"/>
        <div className="row">
          <h3>Action Items</h3>
          <div className="form-group">
            <textarea type="text" className="form-control" placeholder="What do we need to remember to do next week?"
                   value={this.state.action_msg} onChange={this.handleInputChange.bind(this, "action_msg")}/>
          </div>
          <button className="btn btn-primary"
                  onClick={this.addItem.bind(this, "action_msg")}>Add Action Item</button>
          <hr/>
          {actionItems}
        </div>
      </div>
    )
  }
}

export default Room;
