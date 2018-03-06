import * as React from "react"

class ErrorPage extends React.Component<any, any> {
  constructor(props: object) {
    super(props);
    this.redirect = () => {
      window.location = "/";
    }
  }

  render() {
    return (
      <div>
        <h1>Uh Oh! Room not found</h1>
        <img src="https://thumbs.gfycat.com/FarBlandGentoopenguin-size_restricted.gif" onClick={this.redirect} className="clickable"/>
      </div>
    )
  }
}

export default ErrorPage;