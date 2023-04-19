import Link from "next/link";
export default function DashLoading() {
  const list = [1, 2, 3];
  return (
    <div className="panel__low">
      <div className="panel__bottom-title">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <g>
            <path fill="none" d="M0 0h24v24H0z"></path>
            <path
              fillRule="nonzero"
              d="M12 23a7.5 7.5 0 0 0 7.5-7.5c0-.866-.23-1.697-.5-2.47-1.667 1.647-2.933 2.47-3.8 2.47 3.995-7 1.8-10-4.2-14 .5 5-2.796 7.274-4.138 8.537A7.5 7.5 0 0 0 12 23zm.71-17.765c3.241 2.75 3.257 4.887.753 9.274-.761 1.333.202 2.991 1.737 2.991.688 0 1.384-.2 2.119-.595a5.5 5.5 0 1 1-9.087-5.412c.126-.118.765-.685.793-.71.424-.38.773-.717 1.118-1.086 1.23-1.318 2.114-2.78 2.566-4.462z"></path>
          </g>
        </svg>
        <h3>Most Active</h3>
      </div>

      <div className="panel__bottom">
        <div className="panel__stockList">
          <ul className="panel__list">
            {
              //repete 3 times
              list.map((key) => (
                <li key={key}>
                  <Link href={`#`}>
                    <span className="panel__fullname">
                      <h4>
                        <div
                          style={{
                            width: "6vw",
                            height: "1.5vh",

                            display: "inline-block",
                          }}>
                          <div className="linear-background-dash"></div>
                        </div>
                      </h4>
                      <h6 className="panel__name">
                        <div
                          style={{
                            width: "8vw",
                            height: "1vh",

                            display: "inline-block",
                          }}>
                          <div className="linear-background-dash"></div>
                        </div>
                      </h6>
                    </span>
                    <div className="panel__list-change">
                      {/* round to two decimal places */}
                      <h4>
                        <div
                          style={{
                            width: "6vw",
                            height: "1.5vh",
                            display: "inline-block",
                          }}>
                          <div className="linear-background-dash"></div>
                        </div>
                      </h4>

                      <h5
                        style={{
                          color: "rgb(102, 249, 218)",
                          margin: "5px 0px 0px",
                          textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                        }}>
                        <div
                          style={{
                            width: "4vw",
                            height: "1vh",
                            display: "inline-block",
                          }}>
                          <div className="linear-background-dash"></div>
                        </div>
                      </h5>
                    </div>
                  </Link>
                </li>
              ))
            }
          </ul>
        </div>
        <div className="panel__stockList">
          <ul className="panel__list">
            {list.map((key) => (
              <li key={key}>
                <Link href={`#`}>
                  <span className="panel__fullname">
                    <h4>
                      <div
                        style={{
                          width: "6vw",
                          height: "1.5vh",

                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h4>
                    <h6 className="panel__name">
                      <div
                        style={{
                          width: "8vw",
                          height: "1vh",

                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h6>
                  </span>
                  <div className="panel__list-change">
                    {/* round to two decimal places */}
                    <h4>
                      <div
                        style={{
                          width: "6vw",
                          height: "1.5vh",
                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h4>

                    <h5
                      style={{
                        color: "rgb(102, 249, 218)",
                        margin: "5px 0px 0px",
                        textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                      }}>
                      <div
                        style={{
                          width: "4vw",
                          height: "1vh",
                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h5>
                  </div>
                </Link>
              </li>
            ))}
          </ul>
        </div>
        <div className="panel__stockList">
          <ul className="panel__list">
            {list.map((key) => (
              <li key={key}>
                <Link href={`#`}>
                  <span className="panel__fullname">
                    <h4>
                      <div
                        style={{
                          width: "6vw",
                          height: "1.5vh",

                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h4>
                    <h6 className="panel__name">
                      <div
                        style={{
                          width: "8vw",
                          height: "1vh",

                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h6>
                  </span>
                  <div className="panel__list-change">
                    {/* round to two decimal places */}
                    <h4>
                      <div
                        style={{
                          width: "6vw",
                          height: "1.5vh",
                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h4>

                    <h5
                      style={{
                        color: "rgb(102, 249, 218)",
                        margin: "5px 0px 0px",
                        textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                      }}>
                      <div
                        style={{
                          width: "4vw",
                          height: "1vh",
                          display: "inline-block",
                        }}>
                        <div className="linear-background-dash"></div>
                      </div>
                    </h5>
                  </div>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
