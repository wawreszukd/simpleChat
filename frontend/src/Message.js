import { Component } from "react";
import "./Message.css";

export default class Message extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { message, nick } = this.props;

    // Determine the class based on the sender
    const messageClass = message.author === nick ? "right" : "left";

    return(<div className="mess">
        <li className={messageClass}>
          {message.author}: {message.message}
        </li>
      </div>);
  }
}
