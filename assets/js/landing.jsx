import * as React from "react"

class Landing extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
  }


  render() {
    return (
      <div className="jumbotron">
        <h2>Start or join a retro</h2>
        <a className="btn btn-primary" href="/rooms/new"> Create a Retro </a>
        <a className="btn btn-primary" href="/rooms"> Join a Retro </a>
      </div>
    )
  }
}

export default Landing;
