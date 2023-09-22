import { Component } from "react";
import "./Message.css";

export default class Message extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <li
        className={
          this.props.message.author === this.props.message ? "left" : "right"
        }
      >
        {this.props.message.author}: {this.props.message.message}
      </li>
    );
  }
}
