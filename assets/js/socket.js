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

    function setupListener(msg_name, input, container) {
        input.addEventListener("keypress", event => {
            if (event.keyCode === 13) {
                channel.push(msg_name, {body: input.value, room_id: roomId});
                input.value = "";
            }
        });
        channel.on(msg_name, payload => {
            let messageItem = document.createElement("li");
            messageItem.innerText = `${payload.body}`;
            messageItem.className = "thumbnail";
            container.appendChild(messageItem);
        });
    }

    setupListener("happy_msg", happyInput, happyContainer);
    setupListener("middle_msg", middleInput, middleContainer);
    setupListener("sad_msg", sadInput, sadContainer);

    channel.join()
        .receive("ok", resp => {
            console.log("Joined successfully", resp)
        })
        .receive("error", resp => {
            console.log("Unable to join", resp)
        });
}

export default socket;
