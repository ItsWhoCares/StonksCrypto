import React from "react";
import Link from "next/link";
import { useRef } from "react";

export default function SearchBar() {
  const results = useRef();
  const searchBar = useRef();
  const searchBarEl = useRef();
  const searchCoins = async (e) => {
    let result = results.current;
    result.innerHTML = "";
    let b = 0;
    let filter = searchBarEl.current.value.toUpperCase();
    if (e.key === "Enter") {
      window.location = `/coin/${filter}`;
    }
    if (filter.length === 0) {
      result.innerHTML = "";
      result.style.display = "none";
    } else {
      const res = await fetch(
        `https://api.coinranking.com/v2/search-suggestions?query=${filter}`
      );
      const data = await res.json();
      const coins = data.data.coins;

      if (coins.length > 0) {
        result.style.display = "flex";
        coins.forEach((coin) => {
          let el = document.createElement("li");
          el.innerHTML = `<a href="/coin/${coin.uuid}"><h4>${coin.symbol}</h4><h6>${coin.name}</h6></a>`;
          result.appendChild(el);
        });
      }

      // for (let i = 0; i < allSymbols.length; i++) {
      //   // console.log(allSymbols[i])
      //   let splitSymbol = allSymbols[parseInt(i)].split("");
      //   let splitFilter = filter.split("");
      //   for (let a = 0; a < splitFilter.length; a++) {
      //     if (
      //       allSymbols[parseInt(i)].indexOf(filter) > -1 &&
      //       splitSymbol[parseInt(a)] === splitFilter[parseInt(a)]
      //     ) {
      //       if (a === 0) {
      //         results.style.display = "flex";
      //         let el = document.createElement("li");
      //         el.innerHTML = `<a href="/coins/${allSymbols[parseInt(i)]}"><h4>${
      //           allSymbols[parseInt(i)]
      //         }</h4><h6>${allNames[parseInt(i)]}</h6></a>`;
      //         results.appendChild(el);
      //         b++;
      //       }
      //     }
      //   }
      //   if (b === 10) {
      //     break;
      //   }
      // }
    }
  };

  return (
    <div className="topbar__searchbar" ref={searchBar} id="topbar__searchbar">
      <div
        style={{
          display: "flex",
          alignItems: "center",
          width: "100%",
        }}>
        <svg
          enableBackground="new 0 0 250.313 250.313"
          version="1.1"
          viewBox="0 0 250.313 250.313"
          xmlSpace="preserve"
          xmlns="http://www.w3.org/2000/svg">
          <path
            d="m244.19 214.6l-54.379-54.378c-0.289-0.289-0.628-0.491-0.93-0.76 10.7-16.231 16.945-35.66 16.945-56.554 0-56.837-46.075-102.91-102.91-102.91s-102.91 46.075-102.91 102.91c0 56.835 46.074 102.91 102.91 102.91 20.895 0 40.323-6.245 56.554-16.945 0.269 0.301 0.47 0.64 0.759 0.929l54.38 54.38c8.169 8.168 21.413 8.168 29.583 0 8.168-8.169 8.168-21.413 0-29.582zm-141.28-44.458c-37.134 0-67.236-30.102-67.236-67.235 0-37.134 30.103-67.236 67.236-67.236 37.132 0 67.235 30.103 67.235 67.236s-30.103 67.235-67.235 67.235z"
            clipRule="evenodd"
            fill-rule="evenodd"
          />
        </svg>
        <input
          autoCorrect="off"
          autoCapitalize="off"
          spellCheck="false"
          type="text"
          id="searchBar"
          ref={searchBarEl}
          onKeyUp={searchCoins}
          placeholder="Search by symbol"
          onFocus={() => {
            if (results.current.firstChild) {
              results.current.style.display = "flex";
            }
            searchBar.current.style.boxShadow =
              "0px 0px 30px 0px rgba(0,0,0,0.10)";
            results.current.style.boxShadow =
              "0px 30px 20px 0px rgba(0,0,0,0.10)";
          }}
          onBlur={() => {
            setTimeout(() => {
              if (results.current) {
                results.current.style.display = "none";
              }
            }, 300);
            searchBar.current.style.boxShadow = "none";
          }}
          autoComplete="off"
        />
      </div>
      <ul className="topbar__results" id="results" ref={results} />
    </div>
  );
}
