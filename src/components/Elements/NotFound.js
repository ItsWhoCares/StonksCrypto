import Link from "next/link";

export default function NotFound({ errorMsg }) {
  return (
    <>
      <main id="root">
        <div className="container" style={{ height: "100vh" }}>
          <div className="stock">
            <div className="wrongSymbol">
              <h1>Unknown Coin</h1>
              <h2>{errorMsg}</h2>
              <h3>
                Go to{" "}
                <Link href={"/dashboard"} style={{ color: "#fff" }}>
                  Dashboard
                </Link>
              </h3>
            </div>
          </div>
        </div>
      </main>
    </>
  );
}
