import React from "react";
import Link from "next/link";
import SearchBar from "../SearchBar/SearchBar";
import { useUser } from "@supabase/auth-helpers-react";

export default function Topbar() {
  const user = useUser();

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
            <h3>{user?.email}</h3>
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
