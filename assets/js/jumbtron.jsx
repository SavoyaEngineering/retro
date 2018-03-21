import * as React from "react"
import LogoImg from "../static/images/retro.svg";

function Jumbotron(props) {
  return(
    <div className="jumbotron row">
      <div className="col-md-2">
        <img className="logo-landing" alt="Retro" src={LogoImg}/>
      </div>
      <div className="col-md-10">
        <h2>{props.header}</h2>
        <p>{props.message}</p>
      </div>
    </div>
  );
}

export default Jumbotron