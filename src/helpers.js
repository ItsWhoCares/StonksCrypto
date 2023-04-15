export function formatCurrency(amount, notation = "standard", currency = null) {
  let price = new Intl.NumberFormat("en-IN", {
    style: "currency",
    notation: notation,
    currency: currency ?? process.env.NEXT_PUBLIC_REFERENCE_CURRENCY,
    // roundingPriority: amount < 1 ? "morePrecision" : "auto",
    maximumFractionDigits: amount < 1 ? 8 : 2,
  }).format(amount);
  return price;
}

export function formatNumber(amount, notation = "standard") {
  let price = new Intl.NumberFormat("en-IN", {
    style: "decimal",
    notation: notation,
    currency: process.env.NEXT_PUBLIC_REFERENCE_CURRENCY,
  }).format(amount);
  return price;
}

export function getOneDayChart() {}
