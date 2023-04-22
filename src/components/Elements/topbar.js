import { useEffect, useState } from "react";
import Link from "next/link";
import SearchBar from "../SearchBar/SearchBar";
import { useSupabaseClient, useUser } from "@supabase/auth-helpers-react";
import { formatCurrency, getBalance } from "@/helpers";

export default function Topbar() {
  const user = useUser();
  const supabase = useSupabaseClient();
  const [balance, setBalance] = useState(0);
  useEffect(() => {
    if (!user) return;

    getBalance(supabase, user.id).then((balance) => {
      setBalance(balance);
    });
  }, [user]);
  useEffect(() => {
    if (!user) return;

    const userData = supabase
      .channel("custom-update-channel")
      .on(
        "postgres_changes",
        { event: "UPDATE", schema: "public", table: "user_data" },
        (payload) => {
          console.log("Change received!", payload);
          setBalance(payload.new.balance);
        }
      )
      .subscribe();
    return () => {
      userData.unsubscribe();
    };
  }, [user]);

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
            <h3 style={{ paddingRight: 10 }}>{user?.email.split("@")[0]}</h3>
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
                <h3>{formatCurrency(balance)}</h3>
              </div>
            </Link>
            {/* )} */}
          </div>
        </div>
      </div>
    </nav>
  );
}
