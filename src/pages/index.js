import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { useSession, useSupabaseClient } from "@supabase/auth-helpers-react";
import { useEffect } from "react";
import { useRouter } from "next/router";
import Head from "next/head";

export const CustomThemeSupa = {
  default: {
    colors: {
      brand: "hsl(153 60.0% 53.0%)",
      brandAccent: "hsl(154 54.8% 45.1%)",
      brandButtonText: "white",
      defaultButtonBackground: "white",
      defaultButtonBackgroundHover: "#eaeaea",
      defaultButtonBorder: "lightgray",
      defaultButtonText: "gray",
      dividerBackground: "#eaeaea",
      inputBackground: "transparent",
      inputBorder: "lightgray",
      inputBorderHover: "gray",
      inputBorderFocus: "gray",
      inputText: "black",
      inputLabelText: "gray",
      inputPlaceholder: "darkgray",
      messageText: "gray",
      messageTextDanger: "red",
      anchorTextColor: "gray",
      anchorTextHoverColor: "darkgray",
    },
    space: {
      spaceSmall: "4px",
      spaceMedium: "8px",
      spaceLarge: "16px",
      labelBottomMargin: "8px",
      anchorBottomMargin: "4px",
      emailInputSpacing: "4px",
      socialAuthSpacing: "4px",
      buttonPadding: "10px 15px",
      inputPadding: "10px 15px",
    },
    fontSizes: {
      baseBodySize: "13px",
      baseInputSize: "14px",
      baseLabelSize: "14px",
      baseButtonSize: "14px",
    },
    fonts: {
      bodyFontFamily: `ui-sans-serif, sans-serif`,
      buttonFontFamily: `ui-sans-serif, sans-serif`,
      inputFontFamily: `ui-sans-serif, sans-serif`,
      labelFontFamily: `ui-sans-serif, sans-serif`,
    },
    // fontWeights: {},
    // lineHeights: {},
    // letterSpacings: {},
    // sizes: {},
    borderWidths: {
      buttonBorderWidth: "1px",
      inputBorderWidth: "1px",
    },
    // borderStyles: {},
    radii: {
      borderRadiusButton: "4px",
      buttonBorderRadius: "4px",
      inputBorderRadius: "4px",
    },
    // shadows: {
    //   boxShadow: "3px 3px var(--tertiary)",
    // },
    // zIndices: {},
    // transitions: {},
  },
  dark: {
    colors: {
      brandButtonText: "white",
      defaultButtonBackground: "#393e46",
      defaultButtonBackgroundHover: "#393e46",
      // defaultButtonBorder: "#3e3e3e",
      defaultButtonBorder: "#393e46",
      defaultButtonText: "white",
      dividerBackground: "#2e2e2e",
      inputBackground: "#1e1e1e",
      inputBorder: "#3e3e3e",
      inputBorderHover: "gray",
      inputBorderFocus: "gray",
      inputText: "white",
      inputPlaceholder: "darkgray",
    },
  },
};

const Home = () => {
  const router = useRouter();
  const session = useSession();
  const supabase = useSupabaseClient();
  useEffect(() => {
    if (session) {
      router.push("/dashboard");
    }
  }, [session]);
  useEffect(() => {
    const { data: authListener } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (event === "SIGNED_IN") {
          console.log("signed in");
          router.push("/dashboard");
        } else if (event === "SIGNED_OUT") {
          router.push("/");
        }
      }
    );
    return () => {
      authListener.subscription.unsubscribe();
    };
  }, [router, supabase.auth]);

  return (
    <>
      <Head>
        <title>StonksCrypto</title>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <link rel="icon" type="image/png" href="/favicon.png" />
      </Head>
      <div className="auth">
        {!session ? (
          <div className="authcontainer" style={{ padding: "100px 0 100px 0" }}>
            <Auth
              providers={["google", "github"]}
              supabaseClient={supabase}
              appearance={{
                theme: CustomThemeSupa,
                logo: "https://cdn.jsdelivr.net/gh/ItsWhoCares/StonksCrypto@master/public/logo.svg",
              }}
              theme="dark"
            />
          </div>
        ) : (
          <div
            style={{
              display: "flex",
              height: "100vh",
              justifyContent: "center",
              alignContent: "center",
            }}>
            <div className="loading-screen">
              <div className="dot"></div>
              <div className="dot"></div>
              <div className="dot"></div>
              <div className="dot"></div>
              <div className="dot"></div>
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default Home;
