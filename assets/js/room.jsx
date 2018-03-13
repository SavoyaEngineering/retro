import * as React from "react"

import api from './api';
import {Socket} from "phoenix"
import Landing from "./landing";

class Room extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    const url = window.location.pathname;
    const id = url.substring(url.lastIndexOf('/') + 1);

    this.state = {
      id: null,
      name: "",
      emails: "",
      happyItems: [],
      middleItems: [],
      sadItems: [],
      actionItems: [],
      allItems: [],
      happy_msg: "",
      middle_msg: "",
      sad_msg: "",
      action_msg: "",
      showInvite: false,
      members: [],
    };

    this.itemsForColumn = function (type: string) {
      return this.state.allItems.filter(item => {
        return item.type === type;
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
      this.setState({
        id: response.id,
        name: response.name,
        allItems: response.items,
        socketToken: response.socket_token
      });

      this.setupColumnItems(this);

      //setup socket connection
      let socket = new Socket("/socket", {params: {token: this.state.socketToken}});
      socket.connect();
      this.channel = socket.channel("room:" + response.id, {});

      //setup listener for when a retro item is selected
      this.channel.on("select_item", payload => {
        this.state.allItems.map(item => {
          item.selected = payload.item_id === item.id;
        });

        this.setupColumnItems(this);
      });

      //setup listener for when an item is archived
      this.channel.on("archive_item", payload => {
        this.setState({
          allItems: this.state.allItems.filter(item => {
            if (item.id !== payload.item_id) {
              return item;
            }
          })
        });
        this.setupColumnItems();
      });

      //setup thumbs up listener
      this.channel.on("thumbs_up", payload => {
        this.setState({
          allItems: this.state.allItems.map(item => {
            if (item.id === payload.item_id) {
              item.thumbs_up_count += 1;
            }
            return item
          })
        });
      });

      //setup new msg listener
      this.channel.on("new_msg", payload => {
        this.state.allItems.push(payload);
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

  handleTextChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  addItem(type: string) {
    this.channel.push(type, {body: this.state[type], room_id: this.state.id});
    this.setState({[type]: ""})
  }

  focusItem(item, event) {
    event.preventDefault();
    this.channel.push("select_item", {item_id: item.id});
  };

  archiveItem(item) {
    this.channel.push("archive_item", {item_id: item.id});
  };

  thumbsUp(item, event) {
    event.preventDefault();
    this.channel.push("thumbs_up", {item_id: item.id})
  }

  showInvite(event) {
    event.preventDefault();
    this.setState({showInvite: !this.state.showInvite})
  }

  invite(event) {
    event.preventDefault();
    api.post("/api/rooms/" + this.state.id + "/members/invite", {emails: this.state.emails})
      .then(() => {
        this.setState({emails: "", showInvite: false});
        this.getMembers();
      });
  }

  render() {
    this.renderItems = function (items, skipThumbsUp) {
      return items.map((item: object) =>
        <div className="thumbnail" key={item.id}>
          <div className={item.selected ? "caption selected-item" : "caption"} id={item.id}>
            <a onClick={this.focusItem.bind(this, item)} className="center-block" href="#">
              {item.text}
            </a>
            {(!item.selected && !skipThumbsUp) &&
            <button className="btn-sm btn-secondary"
                    onClick={this.thumbsUp.bind(this, item)}>+{item.thumbs_up_count}</button>
            }
            {item.selected &&
            <button className="btn btn-primary"
                    onClick={this.archiveItem.bind(this, item)}>Archive</button>
            }
          </div>
        </div>
      )
    };

    this.memberEmails = function () {
      if (this.state.members !== []) {
        return this.state.members.map(member => member.email).join(", ")
      } else {
        return "No one";
      }
    };

    const happyItems = this.renderItems(this.state.happyItems);
    const middleItems = this.renderItems(this.state.middleItems);
    const sadItems = this.renderItems(this.state.sadItems);
    const actionItems = this.renderItems(this.state.actionItems, true);
    return (
      <div>
        <div className="jumbotron row">
          <div className="col-md-2">
            <img className="logo-landing" alt="Retro" src="../images/retro.svg"/>
          </div>
          <div className="col-md-10">
            <h2>{this.state.name}</h2>
            <p>
              <a onClick={this.showInvite.bind(this)} className="clickable">Invite others to this Retro</a>
            </p>
            {this.state.showInvite &&
              <div>
                <p>Invitations have been sent to: {this.memberEmails()}</p>
                <div className="form-group">
                  <input type="text" className="form-control" placeholder="first@example.com, second@example.com"
                         value={this.state.emails} onChange={this.handleTextChange.bind(this, "emails")}/>
                </div>
                <button className="btn btn-primary"
                        onClick={this.invite.bind(this)}>Send Invite Email</button>
              </div>
            }
          </div>
        </div>
        <div className="row">
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something happy"
                value={this.state.happy_msg} onChange={this.handleTextChange.bind(this, "happy_msg")}/>
            </div>
            <button className="btn btn-primary"
                    onClick={this.addItem.bind(this, "happy_msg")}>Add Item</button>
            <hr/>
            {happyItems}
          </div>
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something meh"
                     value={this.state.middle_msg} onChange={this.handleTextChange.bind(this, "middle_msg")}/>
            </div>
            <button className="btn btn-primary"
                    onClick={this.addItem.bind(this, "middle_msg")}>Add Item</button>
            <hr/>
            {middleItems}
          </div>
          <div className="retro-column">
            <div className="form-group">
              <input type="text" className="form-control" placeholder="Something sad"
                     value={this.state.sad_msg} onChange={this.handleTextChange.bind(this, "sad_msg")}/>
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
                   value={this.state.action_msg} onChange={this.handleTextChange.bind(this, "action_msg")}/>
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
