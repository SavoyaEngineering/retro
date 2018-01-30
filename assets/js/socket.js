//JS to connect the socket/ use channels
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.roomToken}});

socket.connect();

// Now that you are connected, you can join channels with a topic:

let roomId = window.roomId;
if (roomId) {

    let channel = socket.channel("room:" + window.roomId, {});

    let happyInput = document.querySelector("#happy-input");
    let happyContainer = document.querySelector("#happy-column");

    let middleInput = document.querySelector("#middle-input");
    let middleContainer = document.querySelector("#middle-column");

    let sadInput = document.querySelector("#sad-input");
    let sadContainer = document.querySelector("#sad-column");

    //setup behavior for adding items
    function setupNewMessageListener(msg_name, input, container) {
        input.addEventListener("keypress", event => {
            if (event.keyCode === 13) {
                channel.push(msg_name, {body: input.value, room_id: roomId});
                input.value = "";
            }
        });
        channel.on(msg_name, payload => {
            let messageItem = document.createElement("li");
            let itemId = payload.item_id;
            messageItem.innerText = `${payload.body}`;
            messageItem.className = "thumbnail";
            messageItem.id = "item-" + itemId;
            container.appendChild(messageItem);
        });
    }
    setupNewMessageListener("happy_msg", happyInput, happyContainer);
    setupNewMessageListener("middle_msg", middleInput, middleContainer);
    setupNewMessageListener("sad_msg", sadInput, sadContainer);

    // setup behavior for selecting a retro item
    $(document).on('click', '.thumbnail', function (event) {
        let clickedItemID = event.target.id;
        let itemId = clickedItemID.split("item-")[1];
        channel.push("select_item", {item_id: itemId});
    });

    channel.on("select_item", payload => {
        //reset all to be normal
        $("li").each(function (i) {
            let button = this.querySelector("#archive-button");
            if (button !== null) {
                this.removeChild(button);
            }
            this.className = "thumbnail";
        });

        //change the one we care about to be selected
        let elementId = "#item-" + payload.item_id;
        let selectedItem = document.querySelector(elementId);
        selectedItem.className = "selected-item";

        //insert the archive button
        let archiveButton = document.createElement("button");
        archiveButton.className = "btn btn-primary pull-right";
        archiveButton.innerText = "Archive";
        archiveButton.id = "archive-button";
        archiveButton.addEventListener('click', function () {
            channel.push("archive_item", {item_id: payload.item_id});
        });
        selectedItem.appendChild(archiveButton);
    });

    //setup listener for archiving an item
    channel.on("archive_item", payload => {
        //change the one we care about to be archived
        let thing = document.querySelector("#retro-wrapper");
        let elementId = "#item-" + payload.item_id;
        let archivedItem = document.querySelector(elementId);
        archivedItem.parentElement.removeChild(archivedItem);
    });

    //join the channel on load
    channel.join()
        .receive("ok", resp => {
            console.log("Joined successfully", resp)
        })
        .receive("error", resp => {
            console.log("Unable to join", resp)
        });
}

export default socket;
