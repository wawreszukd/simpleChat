import axios from "axios";
import React, { Component } from "react";
import Message from "./Message";
import AddMessage from "./AddMessage";
import Login from "./Login"; // Assuming you have a Login component
import "./Chat.css";

export default class Chat extends Component {
  constructor(props) {
    super(props);
    this.state = {
      messages: [],
      socket: null,
      isLoading: true,
      nickname: "",
      loggedIn: false,
    };
  }

  componentDidMount() {
    const urlParams = new URLSearchParams(window.location.search);
    const nickname = urlParams.get("nickname");
    this.setState({ nickname });

    const socket = new WebSocket("ws://localhost:8765");
    axios
      .get("http://localhost:8000/messages")
      .then((res) => {
        this.setState({ messages: res.data.messages.reverse(), isLoading: false });
      })
      .catch((error) => {
        console.error(error);
        this.setState({ isLoading: false });
      });

    socket.onopen = () => {
      console.log("WebSocket Client Connected");
      this.setState({ socket });
    };

    socket.onmessage = (event) => {
      const chatbox = document.querySelector(".chatbox");
      if (chatbox) {
        chatbox.scrollTop = chatbox.scrollHeight;
      }
    };

    socket.onclose = () => {
      console.log("WebSocket Client Disconnected");
    };

    this.setState({ socket, loggedIn: true }); // Update loggedIn state to true
  }
  componentDidUpdate() {
    const chatbox = document.querySelector(".chatbox");
    if (chatbox) {
      chatbox.scrollTop = chatbox.scrollHeight;
    }
  }
  componentWillUnmount() {
    const { socket } = this.state;
    if (socket) {
      socket.close();
    }
  }
  handleUpdate = (newData) => {
    this.setState({ messages: [...this.state.messages, newData] });
  };
  

  render() {
    const { isLoading, messages, nickname, loggedIn } = this.state;
    return (
      <div className="container">
        {isLoading ? (
          <div>Loading....</div>
        ) : loggedIn && nickname ? (
          <div>
            <div className="chatbox">
              <ul>
                {messages.map((message, index) => (
                  <Message key={index} message={message} nick={nickname} />
                ))}
              </ul>
            </div>
            <div>
              <AddMessage onDatasubmit={this.handleUpdate} socket={this.state.socket} nick={nickname} />
            </div>
          </div>
        ) : (
          <Login />
        )}
      </div>
    );
  }
}
