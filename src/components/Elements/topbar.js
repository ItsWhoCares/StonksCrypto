import React from "react";
import Link from "next/link";
import SearchBar from "../SearchBar/SearchBar";

export default function Topbar() {
  const mobileMenu = React.createRef();
  const hamburger = React.createRef();
  const results = React.createRef();
  const searchBar = React.createRef();
  const searchBarEl = React.createRef();

  const searchStocks = (e) => {
    let results = this.results.current;
    results.innerHTML = "";
    let b = 0;
    let filter = this.searchBarEl.current.value.toUpperCase();
    if (e.key === "Enter") {
      window.location = `/stocks/${filter}`;
    }
    if (filter.length === 0) {
      results.innerHTML = "";
      results.style.display = "none";
    } else {
      for (let i = 0; i < allSymbols.length; i++) {
        // console.log(allSymbols[i])
        let splitSymbol = allSymbols[parseInt(i)].split("");
        let splitFilter = filter.split("");
        for (let a = 0; a < splitFilter.length; a++) {
          if (
            allSymbols[parseInt(i)].indexOf(filter) > -1 &&
            splitSymbol[parseInt(a)] === splitFilter[parseInt(a)]
          ) {
            if (a === 0) {
              results.style.display = "flex";
              let el = document.createElement("li");
              el.innerHTML = `<a href="/stocks/${
                allSymbols[parseInt(i)]
              }"><h4>${allSymbols[parseInt(i)]}</h4><h6>${
                allNames[parseInt(i)]
              }</h6></a>`;
              results.appendChild(el);
              b++;
            }
          }
        }
        if (b === 10) {
          break;
        }
      }
    }
  };

  return (
    <nav style={{ display: "flex", alignItems: "center" }}>
      {/* <div ref={this.mobileMenu} className="mobileMenu" id="mobileMenu">
        <Leftbar></Leftbar>
      </div> */}
      <div className="topbar">
        <div
          className="hamburger"
          //ref={this.hamburger}
        >
          <div className="hamburger__container">
            <div className="hamburger__inner" />
            <div className="hamburger__hidden" />
          </div>
        </div>
        <SearchBar />
        <div className="topbar__container">
          <div className="topbar__user">
            {/* {admin && (
              <Link to="/admin">
                <div className="topbar__dev">
                  <h4>DEV</h4>
                </div>
              </Link>
            )} */}
            {/* {this.state.fundsLoader === true && ( */}
            <Link href={"/portfolio"}>
              <div className="topbar__power">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                  <g>
                    <path fill="none" d="M0 0h24v24H0z" />
                    <path d="M18 7h3a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h15v4zM4 9v10h16V9H4zm0-4v2h12V5H4zm11 8h3v2h-3v-2z" />
                  </g>
                </svg>
                <h3>100,000</h3>
              </div>
            </Link>
            {/* )} */}
          </div>
        </div>
      </div>
    </nav>
  );
}
