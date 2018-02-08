import * as React from "react"
import * as ReactDOM from "react-dom"
import api from './api';
import {Socket} from "phoenix"

class Room extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    const url = window.location.pathname;
    const id = url.substring(url.lastIndexOf('/') + 1);

    this.state = {
      id: null,
      name: "",
      happyItems: [],
      middleItems: [],
      sadItems: [],
      allItems: [],
      happy_msg: "",
      middle_msg: "",
      sad_msg: ""
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
      })
    };

    api.fetch('/api/rooms/' + id)
      .then((response) => {
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
      });
  }

  handleTextChange(type: string, event) {
    this.setState({[type]: event.target.value});
  }

  addItem(type: string) {
    this.channel.push(type, {body: this.state[type], room_id: this.state.id});
    this.setState({[type]: ""})
  }

  focusItem(item) {
    this.channel.push("select_item", {item_id: item.id});
  };

  archiveItem(item) {
    this.channel.push("archive_item", {item_id: item.id});
  };

  render() {
    this.renderItems = function (items) {
      return items.map((item: object) =>
        <li className={item.selected ? "selected-item" : "thumbnail"} key={item.id} id={item.id}
            onClick={this.focusItem.bind(this, item)}>{item.text}
          {item.selected &&
          <button className="btn btn-primary btn-block"
                  onClick={this.archiveItem.bind(this, item)}>Archive</button>
          }
        </li>
      )
    };

    const happyItems = this.renderItems(this.state.happyItems);
    const middleItems = this.renderItems(this.state.middleItems);
    const sadItems = this.renderItems(this.state.sadItems);
    return (
      <div>
        <div className='jumbotron'>
          <h2>{this.state.name}</h2>
        </div>
        <div className="retro-column form-group">
          <input type="text" className="form-control" placeholder="Something happy"
            value={this.state.happy_msg} onChange={this.handleTextChange.bind(this, "happy_msg")}/>
          <button className="btn btn-primary btn-block"
                  onClick={this.addItem.bind(this, "happy_msg")}>Add Item</button>
          <hr/>
          {happyItems}
        </div>
        <div className="retro-column form-group">
          <input type="text" className="form-control" placeholder="Something happy"
                 value={this.state.middle_msg} onChange={this.handleTextChange.bind(this, "middle_msg")}/>
          <button className="btn btn-primary btn-block"
                  onClick={this.addItem.bind(this, "middle_msg")}>Add Item</button>
          <hr/>
          {middleItems}
        </div>
        <div className="retro-column form-group">
          <input type="text" className="form-control" placeholder="Something happy"
                 value={this.state.sad_msg} onChange={this.handleTextChange.bind(this, "sad_msg")}/>
          <button className="btn btn-primary btn-block"
                  onClick={this.addItem.bind(this, "sad_msg")}>Add Item</button>
          <hr/>
          {sadItems}
        </div>
      </div>
    )
  }
}

export default function renderRoom(node) {
  ReactDOM.render(
    (<div>
      <Room/>
    </div>),
    node
  )
}