import { formatCurrency } from "@/helpers";

export default function ConfirmBox({
  quantity,
  coinPrice,
  error = false,
  errorMsg = "",
  setIsVisible,
  buyCoin,
  setErrorMsg,
}) {
  if (error) {
    return (
      <>
        <div class="black-bg" id="blackbg">
          <div class="buyConfirmation" id="confirmbox">
            <h3>{errorMsg}</h3>
            <div>
              <button
                className={"stockPage__buy-button cancel"}
                onClick={() => {
                  setIsVisible(false);
                  setErrorMsg(null);
                }}>
                OK
              </button>
            </div>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <div class="black-bg" id="blackbg"></div>
      <div class="buyConfirmation" id="confirmbox">
        <h3>
          Are you sure you want to buy {quantity} shares of VKTX for{" "}
          <span style={{ fontWeight: "bold" }}>
            {formatCurrency(coinPrice * quantity)}
          </span>
        </h3>

        <div>
          <button
            className={"stockPage__buy-button"}
            onClick={() => {
              buyCoin();
            }}>
            CONFIRM
          </button>
          <button
            className={"stockPage__buy-button cancel"}
            onClick={() => setIsVisible(false)}>
            CANCEL
          </button>
        </div>
      </div>
    </>
  );
}
