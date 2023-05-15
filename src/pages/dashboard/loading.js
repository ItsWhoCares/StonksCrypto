export default function Loading() {
  return (
    <>
      <Head>
        <title>Dashboard</title>
      </Head>
      <>
        <main id="root">
          <div className="container">
            <section className="Dashboard" id="dashboard">
              <div></div>
              <div
                style={{
                  display: "flex",
                  flexDirection: "column",
                  width: "100%",
                }}>
                <div style={{ display: "flex", height: "100%" }}>
                  <Leftbar page={"dashboard"} />

                  <div className="panel">
                    <LeftbarMobile />
                    <Topbar />

                    <div className="panel__container">
                      <div className="panel__top">
                        <div className="panel__title">
                          <div
                            style={{
                              display: "flex",
                              alignItems: "center",
                              width: "33%",
                            }}>
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              className="panel__portfolio-title"
                              viewBox="0 0 24 24">
                              <g>
                                <path fill="none" d="M0 0h24v24H0z"></path>
                                <path d="M4.873 3h14.254a1 1 0 0 1 .809.412l3.823 5.256a.5.5 0 0 1-.037.633L12.367 21.602a.5.5 0 0 1-.706.028c-.007-.006-3.8-4.115-11.383-12.329a.5.5 0 0 1-.037-.633l3.823-5.256A1 1 0 0 1 4.873 3zm.51 2l-2.8 3.85L12 19.05 21.417 8.85 18.617 5H5.383z"></path>
                              </g>
                            </svg>
                            <h3>Portfolio</h3>
                          </div>
                        </div>
                        <div
                          className="panel__topCharts"
                          style={{ display: "flex" }}>
                          <div className="panel__portfolio-section">
                            <div className="panel__portfolio" id="portfolio">
                              <div className="errorMsg">
                                <svg
                                  xmlns="http://www.w3.org/2000/svg"
                                  viewBox="0 0 24 24">
                                  <g>
                                    <path fill="none" d="M0 0h24v24H0z"></path>
                                    <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                                  </g>
                                </svg>
                                <p>You didn't buy any stocks yet.</p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <DashLoading />
                  </div>
                </div>
              </div>
            </section>
          </div>
        </main>
      </>
    </>
  );
}
