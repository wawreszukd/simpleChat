import { Component } from "react";
export default class AddMessage extends Component {
  constructor(props) {
    super(props);
    this.state = { message: "", socket: this.props.socket };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({ message: event.target.value });
  }

  handleSubmit(event) {
    event.preventDefault();
    const { socket } = this.props;
    if (socket) {
      socket.send(
        JSON.stringify({
          type: "message",
          author: this.props.nick,
          message: this.state.message,
        })
      );
      this.props.onDatasubmit({
        author: this.props.nick,
        message: this.state.message,
      })
    }
    this.setState({ message: "" });
  }

  render() {
    return (
      <div>
        <form onSubmit={this.handleSubmit} method="">
          <label>
            Message:
            <input
              type="text"
              name="message"
              value={this.state.message}
              onChange={this.handleChange}
            />
          </label>
          <input type="submit" value="Submit" />
        </form>
      </div>
    );
  }
}
